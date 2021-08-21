extends Control


export var channel_button_scene = preload("res://Scenes/Server/channel_button.tscn")

var guild: Guild
var bot: DiscordBot

onready var channels_container = $HBoxContainer/ChannelContainer/Channels


func _ready() -> void:
	name = guild.name
	
	var channels = yield(guild.get_channels(bot), "completed")
#	print(channels)
	for channel in channels:
		var channel_button = channel_button_scene.instance()
		channel_button.name = channel.name
		if channel.type == 4:
			channel_button.flat = true
			channel_button.icon = null
		channels_container.add_child(channel_button)
