# Osom-Area

Osom-Area is custom textarea wrapper for lovely.io, features:

 * Automatic resize
 * Simplified selections handling

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
    area.selection.position();     // returns the current selection position
    area.selection.position(1,22); // sets current selection position

    area.selection.text();         // returns currently selected text
    area.selection.text('some text'); // selects matching text in the textarea

    area.selection.save();         // saves the current selection range
    area.selection.restore();      // restores previously saved selection range

## Options

 * `autoresize` (default: true) - auto-resize the textarea to fit the text
 * `keepselection` (default: false) - automatically saves/restores the selection range on blur/focus


## Copyright And License

This project is released under the terms of the MIT license

Copyright (C) 2012 Nikolay Nemshilov