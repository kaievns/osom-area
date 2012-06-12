#
# Osom-Area main file
#
# Copyright (C) 2012 Nikolay Nemshilov
#

# hook up dependencies
core     = require('core')
$        = require('dom')
UI       = require('ui')

# local variables assignments
ext      = core.ext
isString = core.isString
isNumber = core.isNumber
Class    = core.Class
Element  = $.Element
Input    = $.Input

# glue in your files
include 'src/osom_area'
include 'src/resizer'
include 'src/selection'
include 'src/painter'

return ext OsomArea,
  Resizer:   Resizer
  Selection: Selection
  Painter:   Painter
  version:   '%{version}'