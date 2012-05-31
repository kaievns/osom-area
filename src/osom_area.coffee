#
# Project's main unit
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class OsomArea extends Input

  constructor: (element, options)->
    element = $(element) if typeof(element) is 'string'
    element = element[0] if element instanceof $.NodeList
    element = element._  if element instanceof Element

    super element

    @resizer = new Resizer(@)

    return @