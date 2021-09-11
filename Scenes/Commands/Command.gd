extends VBoxContainer


const option = preload("res://Scenes/Commands/Options.tscn")

var structure: Dictionary = {
		'name': 'name',
		'description': 'Description',
		'type': 1,
		'guild_id': '',
		'options': [],
		'default_permissions': true,
	} setget set_structure

var recieved_structure: Dictionary = {} setget set_recieved_structure

onready var title = $Title
onready var panel = $Panel
onready var id = $Panel/VBoxContainer/Id
onready var _name = $Panel/VBoxContainer/Name
onready var description = $Panel/VBoxContainer/Description
onready var type = $Panel/VBoxContainer/OptionButton
onready var required = $Panel/VBoxContainer/CheckBox
onready var guild_id = $Panel/VBoxContainer/GuildID
onready var options_container = $Panel/VBoxContainer/OptionsContainer

onready var commands: Array = get_parent().owner.commands

func _ready() -> void:
	commands.append(structure)
	panel.self_modulate = Color(0.211765, 0.223529, 0.247059)


func _process(delta: float) -> void:
	if is_zero_approx(panel.rect_scale.y):
		panel.hide()
	else:
		panel.show()


func _on_Title_toggled(button_pressed: bool) -> void:
	if button_pressed:
		title.icon = preload("res://Assets/GuiTreeArrowDown.svg")
		GlobalTween.fold_panel(panel, true)
		GlobalTween.make_tween(
			panel, "modulate:a",
			0, 1,
			0.5,
			Tween.TRANS_QUART, Tween.EASE_OUT
		)
	else:
		title.icon = preload("res://Assets/GuiTreeArrowRight.svg")
		GlobalTween.fold_panel(panel, false)
		GlobalTween.make_tween(
			panel, "modulate:a",
			1, 0,
			0.5,
			Tween.TRANS_QUART, Tween.EASE_OUT
		)


func _on_Name_text_changed(new_text: String) -> void:
	title.text = new_text.to_lower() if not new_text.empty() else "Name"
	self.structure.name = new_text.to_lower() if new_text else "name"


func _on_Description_text_changed(new_text: String) -> void:
	self.structure.description = new_text if new_text else "description"


func _on_OptionButton_item_selected(index: int) -> void:
	self.structure.type = index + 1


func _on_CheckBox_toggled(button_pressed: bool) -> void:
	self.structure.default_permissions = button_pressed


func _on_GuildID_text_changed(new_text: String) -> void:
	self.structure.guild_id = str(int(new_text))


func _on_Add_pressed() -> void:
	options_container.add_child(option.instance())


func _on_Delete_pressed() -> void:
	commands.remove(get_index())
	get_parent().owner.bot.delete_application_command(str(int(id.bbcode_text)), guild_id.text)
	queue_free()


func _on_Panel_mouse_entered() -> void:
	panel.self_modulate = Color(0.211765, 0.223529, 0.247059)


func _on_Panel_mouse_exited() -> void:
	panel.self_modulate = Color(0.211765, 0.223529, 0.247059)


func set_structure(value: Dictionary) -> void:
	structure = value
	commands[get_index()] = structure

	if value.has("guild_id"):
		guild_id.text = value.guild_id

	if value.has("id"):
		id.bbcode_text = "ID: %s" % value.id


func set_recieved_structure(value: Dictionary):
	if value.has("guild_id"):
		guild_id.text = value.guild_id

	if value.has("id"):
		id.bbcode_text = "ID: %s" % value.id
