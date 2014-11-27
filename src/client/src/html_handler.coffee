define ->
  class @html_handler extends Backbone.View
    el: ".html-wrapper"
    initialize: ->

    # Get identifier for page, call mainView.request_markup
    link_handler: (ident) ->
      moo.request_markup(ident)

    # Insert the markup recieved in the html parameter
    insert_markup: (html) ->
      @$el.html(html)

    # Remove all markup within el
    remove_markup: () ->
      @$el.empty()