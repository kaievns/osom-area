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
    @textarea   = osom_area.style(position: 'relative')

    @min_height = osom_area._.offsetHeight
    @marker     = new Element('div', style: 'display: inline-block; margin: 0; padding: 0; margin-top: 1.2em')

    @$super 'div', style:
      position:   'absolute'
      border:     '0px solid transparent'
      overflow:   'none'
      whiteSpace: 'pre'
      wordWrap:   'break-word'
      color:      'transparent'
      minHeight:  @min_height + 'px'

    @anchor     = new Element('div', style:
      position:   'absolute'
      margin:     '0'
      padding:    '0'
      background: 'none'
      border:     'none'
    ).append(@)

    osom_area.on 'focus', => window.setTimeout (=> @getReady(osom_area)), 1
    osom_area.on 'keyup', => @autoResize(osom_area) if osom_area.options.autoresize
    osom_area.on 'blur',  => @copyBackground(osom_area)

    @getReady(osom_area).autoResize(osom_area)

  #
  # Copies the styles from the textarea
  #
  # @param {OsomArea} original
  # @return {Resizer} this
  #
  getReady: (original)->
    try # the original might not be in the DOM
      @anchor.insertTo(original, 'before')
      @style(original.style('font-size,font-family,width,'+
          'margin-top,margin-left,margin-right,margin-bottom,'+
          'padding-top,padding-left,padding-right,padding-bottom,'+
          'border-top-width,border-left-width,border-right-width,border-bottom-width'))
      @position(original.position())

      @_border_width = parseInt(@style('border-top-width')) || 0
    catch e

    @copyBackground(original)

  #
  # Sets an appropriate size for the original textarea
  #
  # @param {OsomArea} original
  # @return {Resizer} this
  #
  autoResize: (original)->
    @_.innerHTML = original._.value + "\n\n"
    height = @_.offsetHeight - (if @_border_width is 1 then 4 else @_border_width * 2)
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


  #
  # Copies the background colors to the dummy block
  #
  # @param {OsomArea} original
  # @return {Resizer this
  #
  copyBackground: (original)->
    @style(background: original.style(background: '').style('background'))
    original.style(background: 'transparent')

    return @
