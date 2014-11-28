define ->
  class @html_handler extends Backbone.View
    el: ".html-container"
    initialize: ->
      @link_idents = new Array()         # Stores the identifiers for each link
      @link_text = new Array()    # Stores the text for each link to compare to

    # Get identifier for page, call mainView.request_markup
    link_handler: (ident) ->
      console.log 'requesting ' + ident
      #App.Views.text_handler.move_room
      App.Views.mainView.request_markup(ident)

      # Reset the arrays for the new markup that will be loaded
      @link_array = new Array()
      @link_idents = new Array()

    # Insert the markup recieved in the html parameter
    insert_markup: (html) ->
      @$el.html(html)

    # When a new page loads, we need to parse each link in the given markup,
    # and store the integer identifier in the link_idents array, and the link
    # text for late comparison in the link_text array.
    parse_links: (html) =>
      $(html).each('a').each((i, link) ->
        # link is the href from the a tag
        ident = parseInt(link.substring("encore/".length, link.length))
        @link_idents.push(ident)

        # text is the inner text for the a tag
        text = link.innerText
        @link_text.push(text)
      )

    # Remove all markup within el
    remove_markup: () ->
      @$el.empty()