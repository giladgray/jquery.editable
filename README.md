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

#### Example HTML with data-api:
```html
<div class="editable" data-toggle="editable">
    <span class="value">Palantir!</span>
    <span class="edit"><input type="text" value="Palantir"></span>
    <span class="fa fa-pencil editable-trigger"></span>
</div>
```

#### Another example HTML with data-api, where `.value` field is not clickable to edit:
```html
<div class="editable" data-toggle="editable">
    <span class="value" data-clickable-to-edit=false>Click on the icon to start editing!</span>
    <span class="edit"><input type="text" value="Enter new text"></span>
    <span class="fa fa-pencil editable-trigger"></span>
</div>
```

If an element with `editable` class has the `type-update` class as well, then
after every change of the value an `update` event will be fired. This allows
for responding to changes during typing.

#### Example HTML with data-api:
```html
<div class="editable" data-type-update=true data-toggle="editable">
    <span class="value">Start typing!</span>
    <span class="edit"><input type="text" value=""></span>
    <span class="fa fa-pencil editable-trigger"></span>
</div>
```
