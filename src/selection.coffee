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
    @textarea = textarea
    return @

  #
  # Sets/reads the current selection position
  #
  # @param {String|Numeric} the start position
  # @param {String|Numeric} the end position
  # @return {Array} selection position `[start, finish]`
  #
  position: (start, finish)->
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

      textarea.focus()
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

      @position(start, finish)
    else
      start  = @position()

      @textarea._.value.substring(start[0], start[1])
