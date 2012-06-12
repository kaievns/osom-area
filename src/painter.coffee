#
# The text highlighting engine
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class Painter

  #
  # Basic constructor
  #
  # @param {OsomArea} the textarea reference
  # @return {OsomArea.Painter} this
  #
  constructor: (osom_area)->
    @textarea = osom_area
    @reset()

  #
  # Removes all the highlighting tags
  #
  # @return {OsomArea.Painter} this
  #
  reset: ->
    @textarea.mirror.reset();
    return @

  #
  # Figures which blocks of texts should be painted and how
  #
  # @param {String|Number|Regexp} a string/regexp patter to highlight, or an integer starting index
  # @param {Number|String} highlighting end position or the highighting color
  # @param {String|undefined} the highlighting color
  # @return {OsomArea.Painter} this
  #
  highlight: (first, second, third)->
    if first is null
      @reset()
    else if isNumber(first) and isNumber(second)
      @paint(first, second, third)
    else if isString(first)
      console.log(first)
    else if first instanceof Regexp
      console.log(first)

    return @

  #
  # Does the actual painting process
  #
  # @param {Number} start position
  # @param {Number} end position
  # @param {String} color
  # @return {OsomArea.Painter} this
  #
  paint: (start, finish, color)->
    return @ if start is finish
    return @
