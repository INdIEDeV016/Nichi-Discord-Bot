extends Control


export var channel_button_scene = preload("res://Scenes/Server/channel_button.tscn")
export var member_button_scene = preload("res://Scenes/Server/member_button.tscn")
export var message_scene = preload("res://Scenes/Server/message.tscn")

var guild: Guild
var bot: DiscordBot
var current_channel: String setget set_channel

onready var channels_container = $HSplitContainer/ChannelContainer/Channels
onready var members_container = $HSplitContainer/HSplitContainer/MembersContainer/Members
onready var messages_container = $HSplitContainer/HSplitContainer/MessagesContainer/MessageContainer/Messages


func _ready() -> void:
	name = guild.name
	
	for channel in guild.channels:
		var channel_button = channel_button_scene.instance()
		channel_button.channel = channel
		channels_container.add_child(channel_button)
	
	var members = yield(guild.get_members(bot, 1000), "completed")
	for member in members:
		var member_button = member_button_scene.instance()
		member_button.member = member
#		yield(get_tree(), "idle_frame")
		members_container.add_child(member_button)
	
#	current_channel = guild.channels[0].id


func set_channel(value: String) -> void:
	for child in messages_container.get_children():
		child.queue_free()
	
	current_channel = value
	var channel = yield(guild.get_channel(bot, current_channel), "completed")
	var messages: Array = yield(channel.get_messages(bot, channel.id, channel.last_message_id), "completed")
	
	for message in messages:
		message_recieved(message, channel)


func _on_DiscordEdit_text_entered(text: String):
	if text != "":
		Channel.create_message(bot, {"content": text}, current_channel)

func message_recieved(message: Message, channel: Channel):
	if current_channel == channel.id:
		var new_message = message_scene.instance()
#		var avatar = yield(message.author.get_display_avatar({"size": 128}), "completed")
		new_message.bot = bot
		new_message.user_id = message.author.id
		new_message.avatar = message.author.avatar
		new_message.content = message.content
		new_message.id = message.id
		new_message.author_name = message.author.username
		
#		var current_time = OS.get_datetime_from_unix_time(int(message.timestamp))
#		var time_zone = OS.get_time_zone_info()
#		print(time_zone)
		
		new_message.time = "Today at %s" % Helpers.get_time()
		messages_container.add_child(new_message)
