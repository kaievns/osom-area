#
# The text highlighting engine
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class Painter

  #
  # Basic constructor
  #
  # @param {OsomArea} the textarea reference
  # @return {OsomArea.Painter} this
  #
  constructor: (osom_area)->
    @textarea = osom_area
    @markers  = new Lovely.List()
    @reset()

  #
  # Removes all the highlighting tags
  #
  # @return {OsomArea.Painter} this
  #
  reset: ->
    @textarea.mirror.reset();
    return @

  #
  # Figures which blocks of texts should be painted and how
  #
  # @param {String|Number|Regexp} a string/regexp patter to highlight, or an integer starting index
  # @param {Number|String} highlighting end position or the highighting color
  # @param {String|undefined} the highlighting color
  # @return {OsomArea.Painter} this
  #
  highlight: (first, second, third)->
    text = @textarea._.value; @markers = new Lovely.List(); position = 0; index = 0

    if isNumber(first) and isNumber(second)
      @addMarker(first, second, third)

    else if first instanceof RegExp
      while match = text.substr(position).match(first)
        index = text.substr(position).indexOf(match[0])
        @addMarker(position += index, position += match[0].length, second)

    else if isString(first)
      while (index = text.substr(position).indexOf(first)) isnt -1
        @addMarker(position += index, position += first.length, second)

    @paint()

  #
  # Repaints the textarea mirror according the current list of markers
  #
  # @return {OsomArea.Painter} this
  #
  paint: ->
    text = @textarea._.value; html = ''; index = 0

    @markers.forEach (marker)->
      html += text.substring(index, marker[0])
      html += '<span class="highlight'
      html += '" style="background:'+ marker[2] if marker[2]
      html += '">'+ text.substring(marker[0], marker[1]) + '</span>'

      index = marker[1]

    @textarea.mirror._.innerHTML = html

    return @

# protected

  #
  # Adds a marker to the list and
  #
  # @param {Number} start position
  # @param {Number} end position
  # @param {String} color
  # @return {OsomArea.Painter} this
  #
  addMarker: (start, finish, color)->
    return @ if start is finish # skipping empty markers

    # pushing and sorting
    @markers.push([start, finish, color]);
    @markers.sort (a,b)-> a[0] - b[0]

    clean_list  = new Lovely.List()
    prev_marker = [0,0,undefined]

    while marker = @markers.shift()
      if marker[0] < prev_marker[1]    # if current marker intersects with the previous one

        if marker[2] is prev_marker[2] # if the markers have the same color
          prev_marker[1] = marker[1]   # extenting the previous marker to the end of current one
          continue                     # and don't push it into the clean list

        else                           # if colors are different colors
          prev_marker[1] = marker[0]   # shrinking the previous marker to the beginning of the current one

      clean_list.push(marker)

    @markers = clean_list

    return @