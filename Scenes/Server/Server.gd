extends Control


export var channel_button_scene = preload("res://Scenes/Server/channel_button.tscn")
export var member_button_scene = preload("res://Scenes/Server/member_button.tscn")
export var message_scene = preload("res://Scenes/Server/message.tscn")

var guild: Guild
var bot: DiscordBot

onready var channels_container = $HBoxContainer/ChannelContainer/Channels
onready var members_container = $HBoxContainer/MembersContainer/Members
onready var messages_container = $HBoxContainer/VBoxContainer/MarginContainer/MessageContainer/Messages

var current_channel: String

func _ready() -> void:
	name = guild.name
	
	for channel in guild.channels:
		var channel_button = channel_button_scene.instance()
		channel_button.name = channel.id
	
		if channel.type == 4:
			channel_button.flat = true
			channel_button.icon = null
				
		channels_container.add_child(channel_button)
		channel_button.text = channel.name
	channels_container._reset()
	
	for member in guild.members:
		var member_button = member_button_scene.instance()
		member_button.name = member.user.id

		if member.has("nick") and member.nick:
			member_button.text = member.nick
		else:
			member_button.text = member.user.username
	
		members_container.add_child(member_button)
	

func _on_Channels_button_toggled(button_pressed, button):
	if guild.channels_dict.has(button.name) and button_pressed:
		current_channel = guild.channels_dict[button.name].id
		$HBoxContainer/VBoxContainer/DiscordEdit.placeholder.text = "Message #%s" % guild.channels_dict[button.name].name


func _on_DiscordEdit_text_entered(text):
	if text != "":
		Channel.new(guild.channels_dict[current_channel]).send(bot, text)

func message_recieved(message, channel):
	if current_channel == channel.id:
		var new_message = message_scene.instance()
		var avatar = yield(message.author.get_display_avatar({"size": 128}), "completed")
		new_message.avatar = Helpers.to_image_texture(Helpers.to_png_image(avatar))
		new_message.content = message.content
		new_message.author_name = message.author.username
		var current_time = OS.get_datetime_from_unix_time(int(message.timestamp))
		var time_zone = OS.get_time_zone_info()
		print(time_zone)
		new_message.time = "Today at {hour}:{minute}".format(OS.get_datetime_from_unix_time(int(message.timestamp)))
		messages_container.add_child(new_message)
