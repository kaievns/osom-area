#
# Project's main unit
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class OsomArea extends Input
  include: core.Options
  extend:
    Options: # default options
      autoresize:    true
      keepselection: false

  resizer:   null
  selection: null
  menu:      null

  #
  # Basic constructor
  #
  constructor: (element, options)->
    element = $(element) if typeof(element) is 'string'
    element = element[0] if element instanceof $.NodeList
    element = element._  if element instanceof Element

    super element

    @resizer   = new Resizer(@)
    @selection = new Selection(@)
    @menu      = new UI.Menu()

    @menu.on('pick', (event)=> @tryComplete(event.link.text()))

    @setOptions(options)

  #
  # Universal method to work with the selections
  #
  # @param {String|Number} a text to select or the selection start offset
  # @param {Number} the selection finish offset
  # @return {OsomArea} this
  #
  select: (start, finish)->
    if !start?
      return @selection.offsets()
    else if !finish?
      return @selection.text(start)
    else
      @selection.offsets(start, finish)
      return @

  #
  # Autocompleter functionality
  #
  #     Lovely(['osom-area', 'ajax'], function(last_word) {
  #       Ajax.get('some.url?=q'+ last_word, {success: function(response) {
  #         this.autocomplete(response.responseText);
  #       }});
  #     })
  #
  # @param {Function|Array} inital callback or list of options
  # @param {String} the last word location
  # @return {OsomArea} this
  #
  autocomplete: (attr, last_word)->
    switch typeof(attr)
      when 'function'
        return @startCompleteCalls(attr)
      when 'string'
        @menu.update(attr)
      when 'object'
        if attr.length is 0
          @menu.clear()
        else
          @menu.update("<a href='#'>#{attr.join("</a><a href='#'>")}</a>")

    @_requesting = false

    unless @menu.empty()
      # finding the menu position under the last word
      position = @_.value.substr(0, @selection.offsets()[0])
      position = position.substr(0, position.lastIndexOf(last_word || ' ') + (if last_word then 0 else 1))
      position = @resizer.textEndPosition(position)

      @menu.insertTo(@, 'after')
      @menu.position(position)
      @menu.show()

      @_last_word = last_word
    else
      @menu.hide()

    return @

# protected

  #
  # Initializes the auto-completion calls to the callback function
  #
  # @param {Function} callback
  # @return {OsomArea} this
  #
  startCompleteCalls: (callback)->
    @on 'keyup', (event)=>
      return if event.keyCode in [37,38,39,40,13,27,32] # skipping navigation keys and so on

      last_word = @_.value.substr(0, @selection.offsets()[0]).split(/\s+/).pop()

      if last_word && last_word isnt @_prev_last_word && !@_requesting
        @_prev_last_word = last_word
        @_timeout && global.clearTimeout(@_timeout)
        @_timeout = global.setTimeout =>
          @_requesting = true
          @menu.hide()
          callback.call(@, last_word)
        , 200

  #
  # Tries to auto-complete the text from the current position with given string
  #
  # @param {String} text
  # @return {OsomArea} this
  #
  tryComplete: (text)->
    offsets = @selection.offsets()
    value   = @_.value
    start   = value.substr(0, offsets[0])
    end     = value.substr(offsets[1], value.length)

    if @_last_word
      start = start.substr(0, start.lastIndexOf(@_last_word))
    else # merging the start string and the completion text
      for i in [text.length..0]
        if start.substr(start.length - i, start.length) is text.substr(0, i)
          start = start.substr(0, start.length - i)
          break


    @_.value = start + text + end

    offsets = (start + text).length

    @selection.offsets offsets, offsets

    return @
