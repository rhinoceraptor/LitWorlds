// Generated by CoffeeScript 1.7.1
var cheerio, request, scrape,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

request = require('request');

cheerio = require('cheerio');

scrape = (function() {
  function scrape(domain, port, new_domain) {
    this.domain = domain;
    this.port = port;
    this.new_domain = new_domain;
    this.get_html = __bind(this.get_html, this);
    this.base_url = "http://" + this.domain + ":" + port + "/";
    this.new_domain = "http://" + this.new_domain;
  }

  scrape.prototype.get_html = function(url, access_code, callback) {
    var new_html, options;
    console.log("scraping " + url);
    new_html = null;
    options = {
      method: 'GET',
      url: url
    };
    if (access_code !== null) {
      options.headers = {
        'Cookie: ': access_code
      };
    }
    return request(options, (function(_this) {
      return function(err, res, body) {
        var $, links;
        if (!err && res.statusCode === 200) {
          $ = cheerio.load(body);
          links = $('a');
          $(links).each(function(i, link) {
            var ident, new_url, old_url;
            old_url = $(link).attr('href');
            ident = old_url.substring(_this.base_url.length, old_url.length - 1);
            new_url = "#encore/" + ident;
            return $(link).attr('href', new_url);
          });
          return callback($.html());
        }
      };
    })(this));
  };

  return scrape;

})();

module.exports = scrape;
