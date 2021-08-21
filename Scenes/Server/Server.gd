extends Control


export var channel_button_scene = preload("res://Scenes/Server/channel_button.tscn")
export var member_button_scene = preload("res://Scenes/Server/member_button.tscn")

var guild: Guild
var bot: DiscordBot

onready var channels_container = $HBoxContainer/ChannelContainer/Channels
onready var members_container = $HBoxContainer/MembersContainer/Members


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
	
	var members = guild.members
	
	for member in members:
		var member_button = member_button_scene.instance()
		member_button.name = member["user"]["username"]
		member_button.text = member["user"]["username"]
		members_container.add_child(member_button)
	
