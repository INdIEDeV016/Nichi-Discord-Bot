extends PanelContainer


var bot: DiscordBot
var message: Dictionary setget set_message
var id: String
var avatar: ImageTexture
var author_name: String
var content: String
var time: String

onready var server = get_parent().owner
onready var name_node = $HBoxContainer/VBoxContainer/HBoxContainer/Name
onready var time_node = $HBoxContainer/VBoxContainer/HBoxContainer/Time
onready var avatar_node = $HBoxContainer/MarginContainer/Avatar
onready var content_node = $HBoxContainer/VBoxContainer/Content
onready var editted_node = $HBoxContainer/VBoxContainer/HBoxContainer/Editted
onready var text_edit = $HBoxContainer/VBoxContainer/TextEdit

onready var edit_button = $HBoxContainer/HBoxContainer2/Edit

func _ready():
	self_modulate = Color(0.211765, 0.223529, 0.247059)
	edit_mode(false)
	get_parent().move_child(self, 0)
	avatar_node.texture = avatar
	name_node.text = author_name
	time_node.text = time
	content_node.text = content
	
#	set_message(message)


func set_message(value: Dictionary) -> void:
	message = value
	
	id = message.id
	
	content_node.text = String(message.content)
	
	if message.has("avatar"):
		avatar_node.texture = yield(bot._send_get_cdn(message.author.avatar), "completed")
	
	name_node.text = message.author.username
	
	time_node.text = "Today at %s" % message.edited_timestamp


func edit_mode(_bool: bool):
	if _bool:
		content_node.hide()
		text_edit.text = content_node.text
		text_edit.show()
		editted_node.hide()
	else:
		content_node.show()
		content_node.text = text_edit.text
		text_edit.hide()
		editted_node.show()
		edit_button.pressed = _bool


func _on_Delete_pressed() -> void:
	Channel.delete_message(server.bot, id, server.current_channel)
	queue_free()


func _on_Reply_pressed() -> void:
	pass # Replace with function body.


func _on_Edit_toggled(button_pressed: bool) -> void:
	edit_mode(button_pressed)

func _on_TextEdit_gui_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.scancode == KEY_ENTER and not event.shift:
			edit_mode(false)
			Channel.edit_message(server.bot, id, server.current_channel, {"content":text_edit.text})
			time_node.text = "Today at %s" % Helpers.get_time()


func _on_Message_mouse_entered() -> void:
	self_modulate = Color(0.196078, 0.207843, 0.231373)


func _on_Message_mouse_exited() -> void:
	self_modulate = Color(0.211765, 0.223529, 0.247059)
