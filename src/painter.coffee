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
    @markers  = []
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
  # @param {Boolean} pass `true` if you want to keep all previous markers
  # @return {OsomArea.Painter} this
  #
  highlight: (first, second, third, keep)->
    @markers = [] unless keep
    @markers.push([first, second, third])

    @paint()

  #
  # Repaints the textarea mirror according the current list of markers
  #
  # @return {OsomArea.Painter} this
  #
  paint: (text)->
    text or= @textarea._.value; html = ''; index = 0

    for marker in @getMarkers(text)
      html += text.substring(index, marker[0])
      html += '<span class="highlight'
      html += '" style="background:'+ marker[2] if marker[2]
      html += '">'+ text.substring(marker[0], marker[1]) + '</span>'

      index = marker[1]

    html += text.substring(marker[1]) if marker
    @textarea.mirror._.innerHTML = html

    return @

# protected

  #
  # Builds the list of position/color markers out of saved patterns
  #
  # @return {Array} list of markers
  #
  getMarkers: (text)->
    text or= @textarea._.value; markers = []

    for [first, second, third] in @markers
      position = 0; index = 0;

      # a simple point to point marker
      if isNumber(first) and isNumber(second)
        markers.push([first, second, third])

      # a regular expression based marker
      else if first instanceof RegExp
        while match = text.substr(position).match(first)
          index = text.substr(position).indexOf(match[0])
          markers.push([position += index, position += match[0].length, second])

      # a plain text based marker
      else if isString(first)
        while (index = text.substr(position).indexOf(first)) isnt -1
          markers.push([position += index, position += first.length, second])

    markers.sort (a,b)-> a[0] - b[0]

    clean_list  = []; prev_marker = [0,0,undefined]

    while marker = markers.shift()
      if marker[0] < prev_marker[1]    # if current marker intersects with the previous one

        if marker[2] is prev_marker[2] # if the markers have the same color
          prev_marker[1] = marker[1]   # extenting the previous marker to the end of current one
          continue                     # and don't push it into the clean list

        else                           # if colors are different colors
          prev_marker[1] = marker[0]   # shrinking the previous marker to the beginning of the current one

      clean_list.push(marker)

    return clean_list