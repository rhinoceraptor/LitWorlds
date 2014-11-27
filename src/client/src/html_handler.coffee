define ->
  class @html_handler extends Backbone.View
    el: ".html-wrapper"
    initialize: ->
      @$el.on "click", "a", @link_handler

    # Get identifier for page, call mainView.request_markup
    link_handler: (e) ->


    # Insert the markup recieved in the html parameter
    insert_markup: (html) ->
      @$el.html(html)

    # Remove all markup within el
    remove_markup: () ->
      @$el.empty()