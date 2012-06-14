#
# Project's main unit
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class OsomArea extends Input
  include: core.Options
  extend:
    Options: # default options
      autoresize:       true
      keepselection:    false
      minLastWordSize:  2      # minimum size of the last word for the autocompleter to kick in

  mirror:    null
  selection: null
  painter:   null
  menu:      null

  #
  # Basic constructor
  #
  constructor: (element, options)->
    element = $(element) if isString(element)
    element = element[0] if element instanceof $.NodeList
    element = element._  if element instanceof Element

    super element

    @mirror    = new Mirror(@)
    @selection = new Selection(@)
    @menu      = new ContextMenu(@)
    @painter   = new Painter(@)

    @menu.on('pick', (event)=> @tryComplete(event.link.text()))

    @setOptions(options)

    @repaint()

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
    return @startCompleteCalls(attr) if typeof(attr) is 'function'

    @_requesting = false
    @menu.tryShow(attr, last_word)

    return @

  #
  # Just bypassing the arguments to the painter object
  #
  # To reset all the highligthings call the method with `null`
  #
  # @param {String|Number|Regexp} a string/regexp patter to highlight, or an integer starting index
  # @param {Number|String} highlighting end position or the highighting color
  # @param {String|undefined} the highlighting color
  # @return {OsomArea} this
  #
  paint: ->
    @painter.highlight.apply(@painter, arguments)
    return @

  #
  # Calls in the complete resize/repaint on the textarea
  #
  # @return {OsomArea} this
  #
  repaint: ->
    @mirror.resize()
    return @

  # making the textarea to get repainted with a context or style was changed
  value:       -> res = Input::value.apply(@, arguments);   @repaint(); res
  setClass:    -> Element::setClass.apply(@, arguments);    @repaint()
  addClass:    -> Element::addClass.apply(@, arguments);    @repaint()
  removeClass: -> Element::removeClass.apply(@, arguments); @repaint()
  toggleClass: -> Element::toggleClass.apply(@, arguments); @repaint()
  radioClass:  -> Element::radioClass.apply(@, arguments);  @repaint()

# protected

  #
  # Initializes the auto-completion calls to the callback function
  #
  # @param {Function} callback
  # @return {OsomArea} this
  #
  startCompleteCalls: (callback)->
    @on 'keyup', (event)=>
      # skipping navigation keys, keystrokes with modifiers and so on
      return if event.keyCode in [37,38,39,40,13,27,32] or event.altKey or event.ctrlKey or event.metaKey

      last_word = @_.value.substr(0, @selection.offsets()[0]).split(/\s+/).pop()

      if last_word.length >= @options.minLastWordSize && last_word isnt @_prev_last_word && !@_requesting
        @_prev_last_word = last_word
        @_timeout && global.clearTimeout(@_timeout)
        @_timeout = global.setTimeout =>
          @_requesting = true
          @menu.hide()
          if callback.call(@, last_word) is false
            @_requesting = false # allowing the application scripts to skip the completion
        , 100

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
