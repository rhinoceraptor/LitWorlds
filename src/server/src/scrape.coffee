# scrape.coffee
#
# scrape is instantiated for a user session, and is used to modify all encore
# URLs so that the resulting HTML can be AJAXed to the user. The links are
# modified from http://domain.tld:port/int to #encore/int.
# This way, the Backbone.js router can handle those links, and the client app
# will make a call back to the Node.js server for a new page.
#
# Example usage:
# s = new scrape("brn227.brown.wmich.edu", "7000", "literaryworlds.me")
# s.get_html('62', callback)
###############################################################################

request = require 'request'
cheerio = require 'cheerio'

class scrape
  constructor: (@domain, @port, @new_domain) ->
    @base_url = "http://" + @domain + ":" + port + "/"
    @new_domain = "http://" + @new_domain

  get_html: (url, access_code, callback) =>
    console.log "scraping " + url
    new_html = null

    # If we have an access code, use it
    if access_code != null
      options = {
        method: 'GET',
        url: url,
        headers: {'Cookie: ': access_code}
      }
    else
      options = {
        method: 'GET',
        url: url
      }

    request(options, (err, res, body) =>
      if (!err and res.statusCode is 200)
        $ = cheerio.load(body)
        links = $('a')
        $(links).each((i, link) =>
          old_url = $(link).attr('href')
          ident = old_url.substring(@base_url.length, old_url.length - 1)
          new_url = "#encore/" + ident
          $(link).attr('href', new_url)
        )

        callback($('body').html())
    )

module.exports = scrape
