###
jquery.editable
@author Gilad Gray <giladgray@gmail.com>
@date June 16, 2014

A simple plugin for making a piece of text editable through a backing `<input>`
field. Requires the appropriate HTML in place (see example).

There are two ways for user to start editing the text:

1. Clicking on the `editable-trigger` classed icon,

2. Clicking on the text value.

When the edit mode is entered, the text becomes hidden and input is shown.
Setting `data-clickable-to-edit` to `false` on an element will prevent entering edit mode
when that element is clicked.
Typing `enter` key or focusing away from the input will commit the edited text
(unless empty), triggering a `commit` event with the new value and copying it
the text field.

@example Example HTML with data-api:
  <div class="editable" data-toggle="editable">
    <span class="value">Palantir!</span>
    <span class="edit"><input type="text" value="Palantir"></span>
    <span class="fa fa-pencil editable-trigger"></span>
  </div>

@example Another example HTML with data-api, where `.value` field is not clickable to edit:
  <div class="editable" data-toggle="editable">
    <span class="value" data-clickable-to-edit=false>Click on the icon to start editing!</span>
    <span class="edit"><input type="text" value="Enter new text"></span>
    <span class="fa fa-pencil editable-trigger"></span>
  </div>

If an element with `editable` class has the `type-update` class as well, then
after every change of the value an `update` event will be fired. This allows
for responding to changes during typing.

@example Example HTML with data-api:
  <div class="editable" data-type-update=true data-toggle="editable">
    <span class="value">Start typing!</span>
    <span class="edit"><input type="text" value=""></span>
    <span class="fa fa-pencil editable-trigger"></span>
  </div>

###
class Editable
  @TOGGLE: '[data-toggle=editable]'
  @DEFAULTS: {}

  constructor: (element, options) ->
    @$el    = $(element)
    @$input = @$el.find('input')
    @$value = @$el.find('.value')

    # begin editing
    editElements = ['.editable-trigger', '.value']
    clickableElements = _.filter editElements, (selector) =>
      @$el.find(selector).data('clickable-to-edit') isnt false
    @$el.on 'click.editable', clickableElements.join(','), @edit

    # commit edit
    @$input.on 'blur.editable', @commit

    @doNotCommit = false

    # if input is inside an anchor, on Firefox a click on input will
    # trigger a blur before mouseup
    @$input.on 'mousedown', => @doNotCommit = true
    @$input.on 'mouseup', => @doNotCommit = false

    # enter to commit
    @$input.on 'keydown.editable', (evt) =>
      if evt.which is 13 then @$input.blur()
      else if evt.which is 27 then @cancel()

    # keyup so we have the updated input value
    if @$el.attr('data-type-update')
      @$input.on 'keyup.editable', (evt) =>
        if evt.which isnt 13 and evt.which isnt 27 then @update()

  edit: =>
    return true if @$el.hasClass('editing')
    @lastValue = @$input.val()
    @$el.addClass('editing').trigger 'edit'
    # firefox ignores setting the same value, so we reset it
    @$input.val('')
    # move cursor to the right
    @$input.focus().val(@lastValue)
    @update() if @lastValue

    return false

  update: =>
    @$el.trigger 'update', @$input.val()

  commit: =>
    return unless @lastValue and not @doNotCommit
    value = @$input.val() or @lastValue
    if value.length
      @lastValue = null
      @$value.text(value)
      @$input.val(value)
      @$el.removeClass('editing').trigger 'commit', value

  cancel: =>
    @$value.text(@lastValue)
    @$el.removeClass('editing')
    @$input.val(@lastValue)
    @lastValue = null

###
Initialize the Editable plugin on the selected elements.
###
$.fn.editable = (option) -> @each ->
  $this   = $(@)
  data    = $this.data 'editable'
  options = typeof option == 'object' && option

  if not data then $this.data 'editable', data = new Editable(@, options)
  if (typeof option == 'string') then data[option]()

$.fn.editable.Constructor = Editable

$(document).on 'click.editable.data-api', Editable.TOGGLE, (e) ->
  $el = $(e.target)
  unless $el.data('clickable-to-edit') is false
    # find the actual trigger if a child was clicked (like an icon)
    if not $el.has(Editable.TOGGLE).length
      $el = $el.closest Editable.TOGGLE
    # create and show the confirmation button
    $el.editable('edit')
    return false
  # let the event propagate if the element was not clickable to edit
  return true
