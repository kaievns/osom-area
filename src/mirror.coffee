#
# This unit mocks the textarea in a DIV element and allows us
# to calculate the necessary textarea size, absolute text positioning
# emulate text-highlighting and that sort of stuff
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class Mirror extends Element

  #
  # Creates the element and taps into the original
  # textarea events
  #
  # @param {OsomArea} original
  # @return {OsomArea.Mirror} this
  #
  constructor: (osom_area)->
    @textarea   = osom_area.style(position: 'relative')
    @min_height = osom_area._.offsetHeight

    @$super 'div', class: 'osom-area'

    @anchor     = new Element('div', style:
      position:   'absolute'
      margin:     '0'
      padding:    '0'
      background: 'none'
      border:     'none'
    ).append(@)

    osom_area.on 'focus', => window.setTimeout (=> @prepare()), 1
    osom_area.on 'keyup', => @resize() if osom_area.options.autoresize
    osom_area.on 'blur',  => @copyBackground()

    @prepare().style(minHeight: @min_height + 'px')

    @_size_diff = @_.offsetHeight - osom_area._.offsetHeight
    @style(minHeight: (@min_height - @_size_diff) + 'px')

    return @

  #
  # Clones the original textarea styles and positiones the mirror underneath the textarea
  #
  # @return {OsomArea.Mirror} this
  #
  prepare: ()->
    try # the original might not be in the DOM
      @anchor.insertTo(@textarea, 'before')
      @style(@textarea.style('font-size,font-family,width,'+
          'margin-top,margin-left,margin-right,margin-bottom,'+
          'padding-top,padding-left,padding-right,padding-bottom,'+
          'border-top-width,border-left-width,border-right-width,'+
          'border-bottom-width,white-space,word-wrap'))
      @position(@textarea.position())

    catch e

    @copyBackground()

  #
  # Sets an appropriate size for the original textarea
  #
  # @return {OsomArea.Mirror} this
  #
  resize: ()->
    value  = @textarea._.value + "\n\n"

    @textarea.painter.paint(value)

    height = @_.offsetHeight
    height = @min_height if height < @min_height
    @textarea._.style.height = (height - @_size_diff) + 'px'
    return @


  #
  # Calculates the absolute position of the carret position in the text
  # used for the context-menu positioning
  #
  # @param {Numeric} carret position
  # @return {Object} x-y positions
  #
  absolute: (position)->
    text          = @textarea._.value
    @_.innerHTML  = text.substr(0, position) + '<div class="cursor"></div>' + text.substr(position)

    self_position = @position()
    text_position = @textarea.position()
    mark_position = @first('.cursor').position()

    @resize()

    x: text_position.x + mark_position.x - self_position.x
    y: text_position.y + mark_position.y - self_position.y


  #
  # Copies the background colors to the dummy block
  #
  # @return {OsomArea.Mirror} this
  #
  copyBackground: ()->
    @style(background: @textarea.style(background: '').style('background'))
    @textarea.style(background: 'transparent')

    return @

  #
  # Resets the dummy to have the same exact data as the original
  #
  # @return {OsomArea.Mirror} this
  #
  reset: ->
    @_.innerHTML = @textarea._.value
    return @

