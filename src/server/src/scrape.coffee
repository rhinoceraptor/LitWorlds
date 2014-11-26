# scrape.coffee
#
# scrape is instantiated for a user session, and is used to modify all encore
# URLs so that the resulting HTML can be AJAXed to the user. The links are
# modified from http://domain.tld:port/int to http://new_domain.tld#encore/int
# This way, the Backbone.js router can handle those links, and the client app
# will make a call back to the Node.js server for a new page.
#
# Example usage:
# s = new scrape("brn227.brown.wmich.edu", "7000", "literaryworlds.me", io)
# s.change_links('62')
###############################################################################

request = require 'request'
cheerio = require 'cheerio'

class scrape
  constructor: (@domain, @port, @new_domain) ->
    @base_url = "http://" + @domain + ":" + port + "/"
    @new_domain = "http://" + @new_domain
    @new_html = null

  get_html: (req, callback) =>
    req = @base_url + req
    console.log "scraping " + req
    request(req, (err, res, body) =>
      if (!err and res.statusCode is 200)
        $ = cheerio.load(body)
        links = $('a')
        $(links).each((i, link) =>
          old_url = $(link).attr('href')
          ident = old_url.substring(@base_url.length, old_url.length - 1)
          new_url = @new_domain + "#encore/" + ident
          $(link).attr('href', new_url)
          console.log new_url
        )

        @new_html = String($('body').html())
        console.log "new_html:\n" + @new_html
        callback(@new_html)
    )

module.exports = scrape
