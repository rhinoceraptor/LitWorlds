# auth_cookie.coffee
#
# cookie is a class used to store each user session's cooke tokenn for use by
# enCore in keeping text and graphical modes in sync.
#
# We first make a POST back to enCore with some form data: "useridField" and
# "passwordField". These values will come from the frontend login form, if they
# are "" and "", we will use the default value of "Guest" and "".
###############################################################################
request = require 'request'
formstream = require 'formstream'
http = require 'http'
cheerio = require 'cheerio'
jsdom = require 'jsdom'

class auth_cookie
  constructor: (server, port) ->
    @server = server
    @port = port

  # Get an HTTP enCore access code using the user and passwd given
  get_access_code: (user, passwd, callback) =>
    # Create the form to POST
    form = formstream()
    form.field('useridField', user)
    .field('passwordField', passwd)
    .field('xpress', 'Log in')

    options = {
      method: 'POST',
      host: @server,
      port: @port,
      path: '/',
      headers: form.headers()
    }

    req = http.request(options, (res) ->
      if res.headers['set-cookie']
        callback(res.headers['set-cookie'][0])
      else
        callback("failed")
    )
    form.pipe(req);

  # Get an autologin string for telnet using the enCore access code
  get_autologin_string: (access_code, callback) =>
    url = "http://" + @server + ":" + @port + "/Xpress_client/java.html"

    options = {
      method: 'GET',
      url: url,
      headers: {'Cookie: ': access_code}
    }

    # Make a GET request to enCore using the access code given as a cookie
    request(options, (err, res, body) =>
      if !err and res.statusCode is 200
        document = jsdom.jsdom(body)
        if document.location._window.window._java_client_param_pairs
          login = document.location._window.window._java_client_param_pairs[6][1]
          callback(login)
        else
          callback('failed')
      else
        console.log err
    )

module.exports = auth_cookie
