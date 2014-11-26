define ->
  class @html_handler extends Backbone.View
    el: ".html-wrapper"
    initialize: ->
      @$el.on "click", "a", @link_handler

    # Get identifier for page, call mainView.request_markup
    link_handler: (e) ->

    # Remove all the HTML from .html-wrapper, then insert the html parameter
    insert_markup: (html) ->
