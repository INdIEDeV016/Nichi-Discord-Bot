extends Control


var bot: DiscordBot
var message: Message setget set_message

var avatar: ImageTexture
var author: User
var content: String
var time: String

onready var server = get_parent().owner
onready var name_node = $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Name
onready var time_node = $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Time
onready var avatar_node = $VBoxContainer/HBoxContainer/Avatar
onready var content_node = $VBoxContainer/HBoxContainer/VBoxContainer/Content
onready var editted_node = $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Edited
onready var text_edit = $VBoxContainer/HBoxContainer/VBoxContainer/TextEdit
onready var edit_button = $VBoxContainer/HBoxContainer/HBoxContainer2/Edit
onready var reply_button = $VBoxContainer/HBoxContainer/HBoxContainer2/Reply

onready var designer_path = $VBoxContainer/HBoxContainer2/Control/Path2D


func _ready():
	designer_path.get_child(0).points = designer_path.curve.get_baked_points()
	
	self_modulate = Color(0.211765, 0.223529, 0.247059)
	edit_mode(edit_button.pressed)
	editted_node.hide()
	avatar_node.texture = avatar
	name_node.text = author.username
	time_node.text = time
	content_node.text = content
	
	yield(get_tree(), "idle_frame")
	get_parent().move_child(self, get_parent().get_child_count() - 1)
	grab_focus()
	
	yield(GlobalTween.make_tween(
		self, "rect_scale:y",
		0, 1,
		0.5,
		Tween.TRANS_BACK, Tween.EASE_OUT
	), "completed")
	
#	set_message(message)


func set_message(value: Message) -> void:
	message = value
	
	name = message.id
	
	content_node.text = String(message.content)
	
	name_node.text = message.author.username
	
	if message.edited_timestamp:
		time_node.text = "Today at %s" % message.edited_timestamp
		editted_node.show()
	else:
		time_node.text = "Today at %s" % message.timestamp
	
	if author.id != bot.user.id:
		edit_button.hide()
	
	var dict = message
	hint_tooltip = message.print()


func edit_mode(_bool: bool):
	if _bool:
		content_node.hide()
		text_edit.text = content_node.text
		text_edit.show()
		editted_node.show()
	else:
		content_node.show()
		content_node.text = text_edit.text
		text_edit.hide()


func _on_Delete_pressed() -> void:
	yield(GlobalTween.make_tween(
		self, "rect_scale:y",
		1, 0,
		0.5,
		Tween.TRANS_QUART, Tween.EASE_OUT
	), "completed")
	Channel.delete_message(server.bot, name, server.current_channel)
	queue_free()


func _on_Reply_pressed() -> void:
	pass # Replace with function body.


func _on_Edit_toggled(button_pressed: bool) -> void:
	edit_mode(button_pressed)

func _on_TextEdit_gui_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.scancode == KEY_ENTER and not event.shift:
			edit_mode(false)
			Channel.edit_message(server.bot, name, server.current_channel, {"content":text_edit.text})
			time_node.text = "Today at %s" % Helpers.get_time()


func _on_PanelContainer_mouse_exited() -> void:
	self_modulate = Color(0.211765, 0.223529, 0.247059)


func _on_PanelContainer_mouse_entered() -> void:
	self_modulate = Color(0.196078, 0.207843, 0.231373)
