extends Control


export(PackedScene) var server_scene = preload("res://Scenes/Server/Server.tscn")

var current_guild_id: = ""
var current_channel_id: = ""

onready var bot_node = $DiscordBot
onready var tab_container = $TabContainer
onready var console = tab_container.get_node("Console/TextEdit")
onready var server_nodes = tab_container.get_node("Servers")

var servers: Dictionary = {}

func _ready() -> void:
	bot_node.VERBOSE = true
	var file = File.new()
	if !file.file_exists("user://config.cfg"):
		tab_container.current_tab = 1
	else:
		setup_bot("user://config.cfg")
		tab_container.current_tab = 2

func setup_bot(file_path):
	var f = ConfigFile.new()
	f.load(file_path)
	bot_node.INTENTS = f.get_value("Main", "Intents", 32383)
	bot_node.login(f.get_value("Main", "BotToken", ""), f.get_value("Main", "ApplicationID", ""))
	bot_node.set_presence({
		"status": f.get_value("Main", "Status", "idle"),
		"afk": f.get_value("Main", "AFK", false),
		"activity": {
			"type": f.get_value("Main", "Type", "listening"),
			"name": f.get_value("Main", "Name", "you. Please be sane!"),
		}
	})

func _on_DiscordBot_bot_ready(bot: DiscordBot) -> void:
	print("Logged in as |%s#%s|" % [bot.user.username, bot.user.discriminator])
	
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


func _on_DiscordBot_event(_Wbot, event) -> void:
	console.text += Helpers.print_dict(event if not null else "")


func _on_DiscordBot_guild_create(bot: DiscordBot, guild: Guild) -> void:
	var server = server_scene.instance()
	server.guild = guild
	server.bot = bot
	servers[guild.id] = server
	server_nodes.get_node("TabContainer").add_child(server)


func _on_DiscordBot_interaction_create(bot, interaction: DiscordInteraction) -> void:
	pass # Replace with function body.


func _on_DiscordBot_message_create(_bot, message, channel: Channel, guild: Guild):
	print("message received")
	yield(servers[guild.id].message_recieved(message, channel), "completed")
	print("recived")


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_QUIT_REQUEST:
		get_tree().quit()
