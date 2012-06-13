# Osom-Area

Osom-Area is custom textarea wrapper for lovely.io, features:

 * Automatic resize
 * Simplified selections handling
 * Built in context-menu feature
 * Text highlighting feature

## Usage Principles

Hook up the module through the lovely.io interfaces and instantiate
the `OsomArea` class

    :html
    <textarea id="my-area"></textarea>
    <script type="text/javascript">
      Lovely(['osom-area-1.0.0'], function(OsomArea) {
        var area = new OsomArea('#my-area', {options: ...});
      });
    </script>

The first parameter can be either a css rule, a raw dom HTMLTextArea object or a
lovely.io `dom.Input` instance.

## API Reference

The `OsomArea` class is inherited from the `dom.Input` class and has all the same methods.

Additionally it has a shortcut method to work with the selections, called `#select`

    :js
    area.select('some text'); // select a matching piece of text
    area.select(1, 22);       // select a range

    area.select(); // -> returns the current selection range

Also every `OsomArea` instances has a property called `selection` with the following API

    :js
    area.selection.offsets();         // returns the current selection offsets
    area.selection.offsets(1,22);     // sets current selection offsets

    area.selection.text();            // returns currently selected text
    area.selection.text('some text'); // selects matching text in the textarea

    area.selection.position();        // returns absolute position of the cursor in the document

    area.selection.save();            // saves the current selection range
    area.selection.restore();         // restores previously saved selection range

## Options

 * `autoresize` (default: true) - auto-resize the textarea to fit the text
 * `keepselection` (default: false) - automatically saves/restores the selection range on blur/focus
 * `minLastWordSize` (default: 2) - minimal last word size when the autocompleter kicks in


## Autocompletion

`OsomArea` instances have additional method called `#autcoplete` which can take two types of parameters,
a callback function where you can make async calls to the server or an Array of options, so you can hook
up Ajax autocompleter kinda like that

    :js
    Lovely(['osom-area', 'ajax'], function(OsomArea, Ajax) {
      var input = new OsomArea();

      input.autocomplete(function(last_word) {
        Ajax.get('/some-url.json?q='+ last_word, {
          success: function() {
            input.autocomplete(this.responseJSON);
          }
        });
      });
    });


## Text Highlighting

`OsomArea` instances have method called `#paint` which allows you to highlight certain pieces of text

    :js
    var input = new OsomArea()

    input.paint('Nikolay'); // will highlight every 'Nikolay' entry with default yellow color
    input.paint(/nikolay/i, 'pink'); // will hilight everything that matches the re with the pink color
    input.paint(0, 10, 'lightblue'); // will paint a piece of text at the certain position

__NOTE__: this feature is a bit of a dirty hack. Textareas themselves don't support the feature, so
there is a certain lag with the highlighting response when the user types in something in the textarea


## Copyright And License

This project is released under the terms of the MIT license

Copyright (C) 2012 Nikolay Nemshilov