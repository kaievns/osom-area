#
# The textarea selections handler
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class Selection
  #
  # Basic constructor
  #
  # @param {OsomArea} textarea
  # @return {Selection} this
  #
  constructor: (textarea)->
    @textarea = textarea.on
      blur:  -> @selection.save()    if @options.keepselection
      focus: -> @selection.restore() if @options.keepselection

    return @

  #
  # Sets/reads the current selection offsets
  #
  # @param {String|Numeric} the start offset
  # @param {String|Numeric} the end offset
  # @return {Array} selection offsets `[start, finish]`
  #
  offsets: (start, finish)->
    textarea = @textarea._

    if !start? # read it
      start  = textarea.selectionStart
      finish = textarea.selectionEnd
    else # set it
      start  = parseInt(start)  || 0
      finish = parseInt(finish) || 0

      if finish < start
        result = start
        start  = finish
        finish = result

      result = textarea.value.length - 1

      start  = 0 if start  < 0
      finish = 0 if finish < 0
      start  = result if start  > result
      finish = result if finish > result

      textarea.setSelectionRange(start, finish)

    return [start, finish]

  #
  # Either sets the selection text, or returns
  # the currently selected text
  #
  # @param {String|undefined} text to select or nothing if you wanna read it
  # @return {String} selection text
  #
  text: (text)->
    if text?
      finish = @textarea._.value.indexOf(text)

      if finish is -1
        start = finish = 0
      else
        start = finish + text.length

      @offsets(start, finish)
    else
      start  = @offsets()

      @textarea._.value.substring(start[0], start[1])

  #
  # Calculates the absolute physical offset of the current selection start
  #
  # @return {Object} selection position {x: NNN, y: NNN}
  #
  position: ->
    @textarea.resizer.textEndPosition(@textarea._.value.substr(0, @offsets()[0]))

  #
  # Saves the current selection offsets
  #
  save: ->
    @_stash = @offsets()

  #
  # Restores previously saved offsets
  #
  restore: ->
    if @_stash
      window.setTimeout =>
        @offsets(@_stash[0], @_stash[1])
      , 0
