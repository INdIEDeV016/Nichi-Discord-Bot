tool
extends VBoxContainer
class_name ButtonContainer

signal button_pressed(button)
signal button_toggled(button_pressed, button)

var buttons = {}

var _default = 0

var default_button: Button = null
var current_button: Button = null
var _null_button_allowed = true

var _toggle_mode = false

func _ready():
	for child in get_children():
		if child is Button:
			if _toggle_mode:
				child.toggle_mode = _toggle_mode
				child.connect("toggled", self, "_button_toggled", [child])
			child.connect("pressed", self, "_button_pressed", [child])
			buttons[child.name] = child

	if _toggle_mode and buttons.values().size() != 0:
		default_button = buttons.values()[_default]
		default_button.pressed = true
		current_button = default_button
		return

func _reset():
	for child in get_children():
		if child is Button:
			if _toggle_mode:
				child.toggle_mode = _toggle_mode
				if !child.is_connected("toggled", self, "_button_toggled"):
					child.connect("toggled", self, "_button_toggled", [child])
			if !child.is_connected("pressed", self, "_button_pressed"):
				child.connect("pressed", self, "_button_pressed", [child])
			buttons[child.name] = child

	if _toggle_mode:
		default_button = buttons.values()[_default]
		default_button.pressed = true
		current_button = default_button

func _button_pressed(button: Button):
	if Engine.editor_hint:
		return
	emit_signal("button_pressed", button)

func _button_toggled(button_pressed: bool, button: Button):
	for child in buttons.values():
		if child is Button:
			if !button_pressed and current_button == button and !_null_button_allowed:
				current_button.set_block_signals(true)
				current_button.pressed = true
				current_button.set_block_signals(false)

			if button_pressed:
				current_button = button
				child.pressed = false
				if current_button == child:
					current_button.set_block_signals(true)
					current_button.pressed = true
					current_button.set_block_signals(false)

	if Engine.editor_hint:
		return
	emit_signal("button_toggled", button_pressed, button)

func _get_property_list() -> Array:
	var properties = []
	properties.append({
			"name": "toggle_mode",
			"type": TYPE_BOOL
	})
	if _toggle_mode:
		properties.append({
			"name": "default",
			"type": TYPE_INT,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": dict2str(buttons)
		})
		properties.append({
			"name": "null_is_allowed",
			"type": TYPE_BOOL
		})
	return properties

func dict2str(dict) -> String:
	return PoolStringArray(dict.keys()).join(",")

func _get(property: String):
	match property:
		"toggle_mode":
			return _toggle_mode
		"default":
			return _default
		"null_is_allowed":
			return _null_button_allowed

func _set(property: String, value) -> bool:
	match property:
		"toggle_mode":
			_toggle_mode = value
			property_list_changed_notify()
			return true
		"default":
			_default = value
			if is_inside_tree():
				default_button = buttons.values()[_default]
				default_button.pressed = true
				_button_toggled(true, default_button)
			return true
		"null_is_allowed":
			_null_button_allowed = value
			return true
	return false
