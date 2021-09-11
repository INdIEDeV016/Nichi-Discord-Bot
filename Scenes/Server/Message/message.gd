extends Control


var bot: DiscordBot
var message: Message setget set_message

var image = preload("res://Scenes/Server/Message/Image.tscn")

onready var server = get_parent().owner
onready var name_node = $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Name
onready var time_node = $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Time
onready var avatar_node = $VBoxContainer/HBoxContainer/Avatar
onready var content_node = $VBoxContainer/HBoxContainer/VBoxContainer/Content
onready var editted_node = $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Edited
onready var text_edit = $VBoxContainer/HBoxContainer/VBoxContainer/TextEdit
onready var edit_button = $VBoxContainer/HBoxContainer/HBoxContainer2/Edit
onready var reply_button = $VBoxContainer/HBoxContainer/HBoxContainer2/Reply
onready var reply_message = $VBoxContainer/HBoxContainer2

onready var designer_path = $VBoxContainer/HBoxContainer2/Control/Path2D

func _ready():
	designer_path.get_child(0).points = designer_path.curve.get_baked_points()

	self_modulate = Color(0.211765, 0.223529, 0.247059)
	edit_mode(edit_button.pressed)
	editted_node.hide()

	yield(get_tree(), "idle_frame")
	get_parent().move_child(self, get_parent().get_child_count() - 1)
	grab_focus()

	reply_button.get_parent().rect_scale.y = 0

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
	content_node.bbcode_text = String(message.content)
	name_node.text = message.author.username

	if message.edited_timestamp:
		time_node.text = "Today at %s" % message.edited_timestamp
		editted_node.show()
	else:
		time_node.text = "Today at %s" % message.timestamp

	if message.author.id != bot.user.id:
		edit_button.hide()

	var formatted_text: String = content_node.bbcode_text
	if message.mentions:
		for mention in message.mentions:
			formatted_text = formatted_text.replacen("<@!%s>" % mention.id, "[url][color=#5865f2][b]@%s[/b][/color][/url]" % mention.username)

	if message.mention_roles:
		for server_role in server.guild.roles:
			formatted_text = formatted_text.replacen("<@&%s>" % server_role.id, "[color=#%s][b]@%s[/b][/color]" % [Color(str(server_role.color)) if server_role.color != 0 else "5865f2", server_role.name])

	content_node.bbcode_text = formatted_text

	if message.avatar:
		avatar_node.texture = message.avatar

	if message.referenced_message:
		reply_message.get_node("ReplyMessage").text = "@%s %s..." % [message.referenced_message.author.username, message.referenced_message.content.left(20)]
		reply_message.show()

	if message.attachments:
		for attachment in message.attachments:
			if attachment.content_type == "image/png":
				var image_node = image.instance()
				$VBoxContainer/HBoxContainer/VBoxContainer.add_child(image_node)
				var http = image_node.get_node("HTTPRequest")
				http.request(attachment.url)
				var data: Array = yield(http, "request_completed")
				if data[0] == OK and data[1] == HTTPClient.RESPONSE_OK:
					var texture = Helpers.to_image_texture(Helpers.to_png_image(data[-1]))
					image_node.texture = texture
					image_node.get_node("Spinner").hide()
					image_node.rect_min_size = Vector2(clamp(attachment.width, 0, image_node.get_parent().rect_size.x), attachment.height)
				else:
					push_error("Couldn't load image -| Error : %s /|/ Response Code : %s |-" % [data[0], data[1]])
					image_node.queue_free()

	var siblings: Array = Helpers.get_siblings(self)
	if siblings[0].message.author.username == siblings[1].message.author.username and not message.referenced_message:
		var fake_avatar_frame = Control.new()
		fake_avatar_frame.rect_min_size.x = avatar_node.rect_min_size.x
		avatar_node.get_parent().add_child(fake_avatar_frame)
		fake_avatar_frame.get_parent().move_child(fake_avatar_frame, 0)
		avatar_node.hide()
		$VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer.hide()

	var dict = message
	hint_tooltip = message.print()


func edit_mode(_bool: bool):
	if _bool:
		content_node.hide()
		text_edit.text = content_node.bbcode_text
		text_edit.show()
		editted_node.show()
	else:
		content_node.show()
		content_node.bbcode_text = text_edit.text
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


func _on_PanelContainer_mouse_entered() -> void:
	self_modulate = Color(0.196078, 0.207843, 0.231373)
	reply_button.get_parent().rect_scale.y = 1


func _on_PanelContainer_mouse_exited() -> void:
	self_modulate = Color(0.211765, 0.223529, 0.247059)
	reply_button.get_parent().rect_scale.y = 0


#func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
#	if result != OK:
#		push_error("An error occured while making a request for the attachment!")
#
#	if response_code != HTTPClient.RESPONSE_OK:
#		push_error("Request unsuccessful for for attachment: Response Code: %s" % response_code)
