#
# This unit mocks the textarea in a DIV element and allows us
# to calculate the necessary textarea size
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class Resizer extends Element

  #
  # Creates the element and taps into the original
  # textarea events
  #
  # @param {OsomArea} original
  # @return {Resizer} this
  #
  constructor: (osom_area)->
    @$super 'div', style:
      position:   'absolute'
      top:        '-999999em'
      left:       '-999999em'
      border:     '1px solid grey'
      overflow:   'none'
      whiteSpace: 'pre'
      wordWrap:   'break-word'

    @textarea   = osom_area

    @min_height = osom_area._.offsetHeight
    @marker     = new Element('div', style: 'display: inline-block; margin: 0; padding: 0; margin-top: 1.2em')

    osom_area.on 'focus', => @getReady(osom_area)
    osom_area.on 'keyup', => @autoResize(osom_area) if osom_area.options.autoresize

    @getReady(osom_area).autoResize(osom_area)

  #
  # Copies the styles from the textarea
  #
  # @param {OsomArea} original
  # @return {Resizer} this
  #
  getReady: (original)->
    try # the original might not be in the DOM
      @insertTo(original, 'after')
      @style(original.style('font-size,font-family,width,'+
          'margin-top,margin-left,margin-right,margin-bottom,'+
          'padding-top,padding-left,padding-right,padding-bottom'))
    catch e

    return @

  #
  # Sets an appropriate size for the original textarea
  #
  # @param {OsomArea} original
  # @return {Resizer} this
  #
  autoResize: (original)->
    @_.innerHTML = original._.value + "\n\n"
    height = @_.offsetHeight
    height = @min_height if height < @min_height
    original._.style.height = height + 'px'
    return @


  #
  # Calculates the absolute position of the end of the text
  #
  # @param {String} text to measure
  # @return {Object} x-y positions
  #
  textEndPosition: (text)->
    @_.innerHTML = text
    @insert(@marker)

    self_position = @position()
    mark_position = @marker.position()
    text_position = @textarea.position()

    x: text_position.x + mark_position.x - self_position.x
    y: text_position.y + mark_position.y - self_position.y

