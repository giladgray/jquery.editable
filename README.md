# jquery.editable

> click to edit

A simple plugin for making a piece of text editable through a backing `<input>`
field. Requires the appropriate HTML in place (see example).

There are two ways for user to start editing the text:

1. Clicking on the `editable-trigger` classed icon.
2. Clicking on the text value.

When the edit mode is entered, the text becomes hidden and input is shown.

Typing `enter` key or focusing away from the input will commit the edited text (unless empty), triggering a `commit` event with the new value and copying it the text field.

Setting `data-clickable-to-edit` to `false` on an element will prevent entering edit mode when that element is clicked.

## API


#### Basic Usage

The following HTML structure is the most basic requirement for using this plugin.

```html
<div class="editable">
    <span class="value">initial text value</span>
    <span class="edit"><input type="text" value="initial text value"></span>
    <span class="fa fa-pencil editable-trigger"></span>
</div>
```

The plugin can be enabled by calling `.editable()` on a jQuery selector, or preferably by using the `data-` attribute API described below.

```js
$('.editable').editable()
```

Currently, no options are supported via JavaScript. Customize behavior using the `data-` attributes described below.

## Supported `data-` attributes

#### `data-toggle`

```html
<div class="editable" data-toggle="editable">
    <span class="value">Palantir!</span>
    <span class="edit"><input type="text" value="Palantir"></span>
    <span class="fa fa-pencil editable-trigger"></span>
</div>
```

Adding `data-toggle="editable"` attribute to the parent element will automatically enable the plugin when any element inside is clicked upon.

#### `data-clickable-to-edit`
```html
<div class="editable" data-toggle="editable">
    <span class="value" data-clickable-to-edit=false>Click on the icon to start editing!</span>
    <span class="edit"><input type="text" value="Enter new text"></span>
    <span class="fa fa-pencil editable-trigger"></span>
</div>
```
Adding `data-clickable-to-edit` attribute to any child element will prevent entering edit state when clicking on that element.

#### `data-type-update`

```html
<div class="editable" data-type-update=true data-toggle="editable">
    <span class="value">Start typing!</span>
    <span class="edit"><input type="text" value=""></span>
    <span class="fa fa-pencil editable-trigger"></span>
</div>
```

If the parent element has the `data-type-update` attribute as well, then after every change of the value an `update` event will be fired. This allows for responding to changes during typing.

## Events

A number of special events are triggered on the parent element (`.editable` in the examples here) as a result of user interaction.

#### `edit`

The `edit` event is triggered when editing mode is entered by clicking on `.value` or `.editable-trigger`. It receives no arguments.

```js
$('.editable').on('edit', function(event) { /* editing... */ })
```

#### `commit`

The `commit` event is triggered when editing mode is exited by pressing the `enter` key or blurring (un-focusing) the text input. It receives one argument, the committed text.

```js
$('.editable').on('commit', function(event, value) { /* value is new text */ })
```

#### `cancel`

The `cancel` event is triggered when editing mode is exited by pressing the `escape` key. It receives one argument, the previous value of the input before any changes were made.

```js
$('.editable').on('commit', function(event, value) { /* value is previous text */ })
```

#### `update`

The `update` event is triggered after each keypress by the user while editing, if the `data-type-update` attribute is present. It receives one argument, the current text value of the input.

```js
$('.editable').on('update', function(event, value) { /* value is current text */ })
```
