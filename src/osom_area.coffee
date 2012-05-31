#
# Project's main unit
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class OsomArea extends Input
  include: core.Options
  extend:
    Options: # default options
      autoresize:    true
      keepselection: false

  resizer:   null
  selection: null

  #
  # Basic constructor
  #
  constructor: (element, options)->
    element = $(element) if typeof(element) is 'string'
    element = element[0] if element instanceof $.NodeList
    element = element._  if element instanceof Element

    super element

    @resizer   = new Resizer(@)
    @selection = new Selection(@)

    @setOptions(options)

  #
  # Universal method to work with the selections
  #
  # @param {String|Number} a text to select or the selection start position
  # @param {String|Number} the finish position
  # @return {OsomArea} this
  #
  select: (start, finish)->
    if !start?
      return @selection.position()
    else if !finish?
      return @selection.text(start)
    else
      @selection.position(start, finish)
      return @
