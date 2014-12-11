define ->
  class @html_handler extends Backbone.View
    el: ".html-container"
    events:
      "click #btn-back": "back"
      "click #btn-forward": "forward"
    @link_idents = null           # Stores the identifiers for each link
    @link_text = null      # Stores the text for each link to compare to
    @prev_links = null
    @next_links = null
    @cur_ident = 62

    initialize: =>
      @link_idents = []
      @link_text = []
      @prev_links = []
      @next_links = []

    # When the user clicks the back button, we want to pop an identifier from
    # prev_links, and load it. Then, push the cur_ident onto next_links, and
    # set cur_ident to the popped value from prev_links.
    back: () =>
      if @prev_links.length > 0
        ident = @prev_links.pop()
        @link_handler(ident)
        console.log "back, moving to #{ident}, pushing #{@cur_ident} to next_links"
        @next_links.push(@cur_ident)
        @cur_ident = ident

    # When the user clicks the forward button, we want to pop a link from
    # next_links, load it, and push the current link onto prev_links, and set
    # cur_ident to the popped link.
    forward: () =>
      if @next_links.length > 0
        ident = @next_links.pop()
        @link_handler(ident)
        console.log "forward, moving to #{ident}, pushing #{@cur_ident} to prev_links"
        @prev_links.push(@cur_ident)
        @cur_ident = ident

    # Get identifier for page, call mainView.request_markup
    link_handler: (ident) ->
      App.Views.mainView.request_markup(ident)
      # Reset the link arrays for the new markup that will be loaded
      @link_array = []
      @link_idents = []

      # Push the current identifier to the prev_links array
      @prev_links.push(@cur_ident)

      @cur_ident = ident
      console.log "cur_ident is #{@cur_ident}"

    # Insert the markup recieved in the html parameter
    insert_markup: (html) ->
      console.log 'placing html in html container'
      $('.html-container').html(html)


    # Keep the scroll position at the bottom of the scroll buffer when new
    # text is added to it.
    scroll_window: () ->
      $html_out = $(".html-container")
      $html_out.scrollTop(0)

    # Remove all markup within el
    remove_markup: () ->
      $('.html-container').empty()