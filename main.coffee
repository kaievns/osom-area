#
# Osom-Area main file
#
# Copyright (C) 2012 Nikolay Nemshilov
#

# hook up dependencies
core    = require('core')
$       = require('dom')

# local variables assignments
ext     = core.ext
Class   = core.Class
Element = $.Element
Input   = $.Input

# glue in your files
include 'src/osom_area'
include 'src/resizer'

return ext OsomArea,
  version: '%{version}'