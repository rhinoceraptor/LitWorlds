define ->
  class @html_handler extends Backbone.View
    el: ".html-wrapper"
    initialize: ->
      @$el.on "click", "a", @link_handler


     link_handler: (e) ->
