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

    @min_height = osom_area._.offsetHeight

    osom_area.on 'focus', => @getReady(osom_area)
    osom_area.on 'keyup', => @autoResize(osom_area) if osom_area.options.autoresize

    @autoResize(osom_area)

  #
  # Copies the styles from the textarea
  #
  # @param {OsomArea} original
  # @return {Resizer} this
  #
  getReady: (original)->
    @insertTo(original, 'after')
    @style(original.style('font-size,font-family,width,'+
        'margin-top,margin-left,margin-right,margin-bottom,'+
        'padding-top,padding-left,padding-right,padding-bottom'))

  #
  # Sets an appropriate size for the original textarea
  #
  # @param {OsomArea} original
  # @return {Resizer} this
  #
  autoResize: (original)->
    @_.innerHTML = original._.value + "\n\n"
    height = @_.offsetHeight
    if height > @min_height
      original._.style.height = height + 'px'
    return @

