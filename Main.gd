extends Control


export(PackedScene) var server_scene = preload("res://Scenes/Server/Server.tscn")

var discord_bot: DiscordBot
var current_guild_id: = ""
var current_channel_id: = ""

onready var bot_node = $DiscordBot
onready var console = $TabContainer/Console/TextEdit
onready var server_nodes = $TabContainer/Servers

var servers: Dictionary = {}

func _ready() -> void:
	bot_node.VERBOSE = true
#	var file = File.new()
#	file.open("user://token.txt", File.READ)
#	bot_node.login(file.get_as_text(), "752032157580656752")


func _on_DiscordBot_bot_ready(bot: DiscordBot) -> void:
	discord_bot = bot
	bot.set_presence({
		"status": "idle",
		"afk": false,
		"activity": {
			"type": "listening",
			"name": "you. Please be sane",
		}
	})
	
	print("Logged in as %s#%s" % [bot.user.username, bot.user.discriminator])
	
	var servers: Array = []
	for guild in bot.guilds:
		servers.append(bot.guilds[guild].name)
	print("Ready on %s servers (guilds): %s and %s channels" % [bot.guilds.size(), servers,  bot.channels.size()])
	
#	bot_node.add_application_commands(
#		{
#			'name': 'kill',
#			'description': 'This is a server Kill Switch. Only to be used by server owner!',
#			'type': 1,
#			'options': [
#				{
#					'name': 'name',
#					'type': 3,
#					'description': 'no description',
#					'required': true,
#					'choices': [
#						{
#							'name': 'NoName',
#							'value': 'NoValue'
#						}
#					]
#				}
#			],
#			'default_permission': false
#		},
#		"816329865132900352"
#	)


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_QUIT_REQUEST:
		get_tree().quit()



func _on_DiscordBot_event(_Wbot, event) -> void:
	console.text += Helpers.print_dict(event if not null else "")


func _on_DiscordBot_guild_create(bot: DiscordBot, guild: Guild) -> void:
	var server = server_scene.instance()
	server.guild = guild
	server.bot = bot
	servers[guild.id] = server
	server_nodes.get_node("TabContainer").add_child(server)
	
	


func _on_DiscordBot_interaction_create(bot, interaction) -> void:
	pass # Replace with function body.


func _on_TabContainer_tab_changed(tab: int) -> void:
	pass # Replace with function body.


func _on_DiscordBot_message_create(bot, message, channel, guild):
	servers[guild.id].message_recieved(message, channel)
