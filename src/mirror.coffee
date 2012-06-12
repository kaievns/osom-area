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

    @$super 'div', class: 'osom-area', style: minHeight: @min_height + 'px'

    @anchor     = new Element('div', style:
      position:   'absolute'
      margin:     '0'
      padding:    '0'
      background: 'none'
      border:     'none'
    ).append(@)

    osom_area.on 'focus', => window.setTimeout (=> @prepare(osom_area)), 1
    osom_area.on 'keyup', => @resize(osom_area) if osom_area.options.autoresize
    osom_area.on 'blur',  => @copyBackground(osom_area)

    @prepare(osom_area).resize(osom_area)

  #
  # Clones the original textarea styles and positiones the mirror underneath the textarea
  #
  # @param {OsomArea} original
  # @return {OsomArea.Mirror} this
  #
  prepare: (original)->
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
  # @return {OsomArea.Mirror} this
  #
  resize: (original)->
    @_.innerHTML = original._.value + "\n\n"
    height = @_.offsetHeight - (if @_border_width is 1 then 4 else @_border_width * 2)
    height = @min_height if height < @min_height
    original._.style.height = height + 'px'
    return @


  #
  # Calculates the absolute position of the carret position in the text
  # used for the context-menu positioning
  #
  # @param {Numeric} carret position
  # @return {Object} x-y positions
  #
  absolute: (position)->
    text          = @_.innerHTML
    @_.innerHTML  = text.substr(0, position) + '<div class="cursor"></div>' + text.substr(position)

    self_position = @position()
    text_position = @textarea.position()
    mark_position = @first('.cursor').position()

    x: text_position.x + mark_position.x - self_position.x
    y: text_position.y + mark_position.y - self_position.y


  #
  # Copies the background colors to the dummy block
  #
  # @param {OsomArea} original
  # @return {OsomArea.Mirror} this
  #
  copyBackground: (original)->
    @style(background: original.style(background: '').style('background'))
    original.style(background: 'transparent')

    return @

  #
  # Resets the dummy to have the same exact data as the original
  #
  # @return {OsomArea.Mirror} this
  #
  reset: ->
    @_.innerHTML = @textarea._.value
    return @

