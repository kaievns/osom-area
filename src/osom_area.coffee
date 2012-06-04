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
  menu:      null

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
    @menu      = new UI.Menu()

    @setOptions(options)

  #
  # Universal method to work with the selections
  #
  # @param {String|Number} a text to select or the selection start offset
  # @param {Number} the selection finish offset
  # @return {OsomArea} this
  #
  select: (start, finish)->
    if !start?
      return @selection.offsets()
    else if !finish?
      return @selection.text(start)
    else
      @selection.offsets(start, finish)
      return @

  #
  # Autocompleter functionality
  #
  #     Lovely(['osom-area', 'ajax'], function(last_word) {
  #       Ajax.get('some.url?=q'+ last_word, {success: function(response) {
  #         this.autocomplete(response.responseText);
  #       }});
  #     })
  #
  # @param {Function|Array} inital callback or list of options
  # @return {OsomArea} this
  #
  autocomplete: (attr)->
    switch typeof(attr)
      when 'function'
        return @startCompleteCalls(attr)
      when 'string'
        @menu.update(attr)
      when 'object'
        @menu.update("<a href='#'>#{attr.join("</a><a href='#'>")}</a>")

    @_requesting = false

    return @

# protected

  #
  # Initializes the auto-completion calls to the callback function
  #
  # @param {Function} callback
  # @return {OsomArea} this
  #
  startCompleteCalls: (callback)->
    @on 'keyup', =>
      last_word = @_.value.substr(0, @selection.position()[0]).split(/\s+/).pop()

      if last_word && last_word isnt @_prev_last_word && !@_requesting
        @_prev_last_word = last_word
        @_timeout && global.clearTimeout(@_timeout)
        @_timeout = global.setTimeout =>
          @_requesting = true
          callback.call(@, last_word)
        , 200