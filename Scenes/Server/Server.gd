extends Control


export var channel_button_scene = preload("res://Scenes/Server/channel_button.tscn")
export var member_button_scene = preload("res://Scenes/Server/member_button.tscn")
export var message_scene = preload("res://Scenes/Server/message.tscn")

var guild: Guild
var bot: DiscordBot
var current_channel: String setget set_channel
var referenced_message: Dictionary

onready var channels_container = $HSplitContainer/ChannelContainer/Channels
onready var members_container = $HSplitContainer/HSplitContainer/MembersContainer/Members
onready var messages_container = $HSplitContainer/HSplitContainer/MessagesContainer/MessageContainer/Messages
onready var typing_label = $HSplitContainer/HSplitContainer/MessagesContainer/Typing
onready var timer = $Timer
onready var discord_edit = $HSplitContainer/HSplitContainer/MessagesContainer/DiscordEdit

func _ready() -> void:
	name = guild.name
	
	for channel in guild.channels:
		var channel_button = channel_button_scene.instance()
		channel_button.channel = channel
		channels_container.add_child(channel_button)
	
	var members = yield(guild.get_members(bot, 1000), "completed")
	for member in members:
		yield(get_tree(), "idle_frame")
		var member_button = member_button_scene.instance()
		var avatar = yield(member.user.get_display_avatar({size = 128}), "completed")
		member_button.icon = Helpers.to_image_texture(Helpers.to_png_image(avatar))
		member_button.member = member
#		yield(get_tree(), "idle_frame")
		members_container.add_child(member_button)
	
	bot.connect("typing_start", self, "set_typing")
#	current_channel = guild.channels[0].id


func set_channel(value: String) -> void:
	current_channel = value
	for child in messages_container.get_children():
		child.queue_free()
	
	var channel: Channel = yield(guild.get_channel(bot, current_channel), "completed")
	var messages: Array = yield(channel.get_messages(bot, channel.id, channel.last_message_id), "completed")
	
	for message in messages:
		yield(get_tree(), "idle_frame")
		message_recieved(message, channel)
	

	discord_edit.placeholder_text = "Message #%s" % channel.name
	discord_edit.update()

#	var last_message: Message = yield(channel.get_message(bot, channel.last_message_id, channel.id), "completed")
#	message_recieved(last_message, channel)


func reply_pressed(message: Message):
	$HSplitContainer/HSplitContainer/MessagesContainer/ReplyMessage.text = "Replying to %s" % message.author.username
	$HSplitContainer/HSplitContainer/MessagesContainer/ReplyMessage.show()
	print(message.guild_id, "test", message.channel_id, message.id)
	if message.guild_id:
		referenced_message = {"message_id": message.id, "channel_id": message.channel_id, "guild_id": message.guild_id}
	else:
		referenced_message = {"message_id": message.id, "channel_id": message.channel_id}
	

func _on_DiscordEdit_text_entered(text: String):
	if text != "":
		if referenced_message:
			Channel.create_message(bot, {"content": text, "message_reference": referenced_message, "type": 19}, current_channel)
		else:
			Channel.create_message(bot, {"content": text}, current_channel)
		if $HSplitContainer/HSplitContainer/MessagesContainer/ReplyMessage.visible:
			$HSplitContainer/HSplitContainer/MessagesContainer/ReplyMessage.hide()
			referenced_message = {}

func message_recieved(message: Message, channel: Channel):
	typing_label.hide()
	if current_channel == channel.id:
#		yield(get_tree(), "idle_frame")
		if message.author is Dictionary:
			message.author = User.new(bot, message.author)
		
		var new_message = message_scene.instance()
#		var avatar = yield(message.author.get_display_avatar({"size": 128}), "completed")
		new_message.bot = bot
		var avatar = yield(message.author.get_display_avatar({"size": 128}), "completed") # this is what Godot Docs say to use.
		new_message.avatar = Helpers.to_image_texture(Helpers.to_png_image(avatar))
		new_message.content = message.content
		new_message.name = message.id
		new_message.author_name = message.author.username
		var timestamp
		if message.edited_timestamp:
			timestamp = Helpers.get_local_time(message.edited_timestamp)
		else:
			timestamp = Helpers.get_local_time(message.timestamp)
		new_message.time = "%s %s" % [Helpers.get_date(timestamp), Helpers.get_time(timestamp)]
		
		new_message.author = message.author
		new_message.content = message.content
		new_message.name = message.id
    
		messages_container.add_child(new_message)
		new_message.connect("reply_pressed", self, "reply_pressed", [message])
		new_message.message = message
		if message.edited_timestamp:
			new_message.edited_node.show()
#		new_message.get_parent().move_child(new_message, 0)


func set_typing(bot, dict: Dictionary):
	if current_channel == dict.channel_id and dict.member.user.id != bot.user.id:
		timer.start()
		if dict.member.has("nick") and dict.member.nick:
			typing_label.text = "%s is typing..." % dict.member.nick
		elif dict.member.user.has("username") and dict.member.user.username:
			typing_label.text = "%s is typing..." % dict.member.user.username
		typing_label.show()


func _on_Timer_timeout() -> void:
	typing_label.hide()


func _on_DiscordEdit_text_changed(text):
	Channel.send_typing(bot, current_channel)
