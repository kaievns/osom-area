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
include 'src/mirror'
include 'src/selection'
include 'src/context_menu'
include 'src/painter'

exports = ext OsomArea,
  version:     '%{version}'
  Mirror:      Mirror
  Selection:   Selection
  ContextMenu: ContextMenu
  Painter:     Painter
