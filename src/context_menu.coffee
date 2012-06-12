#
# The context menu unit. Handles context-menu related things
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class ContextMenu extends UI.Menu

  #
  # Basic constructor
  #
  # @param {OsomArea} textarea
  # @return {OsomArea.ContextMenu} this
  #
  constructor: (osom_area)->
    @textarea = osom_area
    super()

  #
  # Tries to show the data to the user
  #
  # @param {String|Array} data
  # @param {String} optional last word reference
  # @return {OsomArea.ContextMenu} this
  #
  tryShow: (data, last_word)->
    data = "<a href='#'>#{data.join("</a><a href='#'>")}</a>" if isArray(data)

    @update(data)

    unless @text() is ''
      # finding the menu position under the last word
      position = @textarea.value().substr(0, @textarea.selection.offsets()[0])
      position = position.substr(0, position.lastIndexOf(last_word || @textarea._prev_last_word))
      position = @textarea.resizer.textEndPosition(position)

      @insertTo(@textarea, 'after')
      @position(position)
      @show()

      @textarea._last_word = last_word || @textarea._prev_last_word
    else
      @hide()

    return @
