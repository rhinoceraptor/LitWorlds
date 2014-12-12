define ->
  class @html_handler extends Backbone.View
    el: ".html-wrapper"

    # Get identifier for page, call mainView.request_markup
    link_handler: (ident) ->
      console.log "handling " + ident
      App.Views.mainView.request_markup(ident)

    # Insert the markup recieved in the html parameter
    insert_markup: (html, ident) ->
      console.log 'placing html in html container'
      $('.html-container').html(html)

    # Insert the menu frame
    insert_toolbar: (html) ->
      console.log 'reloading the xpress toolbar'
      $('.xpress-toolbar').html(html)

    # Keep the scroll position at the bottom of the scroll buffer when new
    # text is added to it.
    scroll_window: () ->
      $html_out = $(".html-container")
      $html_out.scrollTop(0)

    # Remove all markup within el
    remove_markup: () ->
      $('.html-container').empty()
      $('.xpress-toolbar').empty()