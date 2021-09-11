extends Control


const command = preload("res://Scenes/Commands/Command.tscn")
var commands: Array = [] setget set_commands

onready var bot: DiscordBot = get_parent().owner.get_node("DiscordBot")
onready var commands_container = $Panel/HSplitContainer/Panel/VBoxContainer/ScrollContainer/CommandsContainer
onready var blur_panel = $Panel/HSplitContainer/Panel


func _ready() -> void:
	get_parent().set_tab_disabled(get_index(), true)


func _process(delta: float) -> void:
	$Panel/HSplitContainer/Structure.bbcode_text = Helpers.print_dict(commands)


func _on_DiscordBot_bot_ready(_bot) -> void:
	bot = _bot
	get_parent().set_tab_disabled(get_index(), false)

#	self.commands = yield(bot._send_get("/applications/%s/commands" % bot.APPLICATION_ID), "completed")
#	for guild_id in bot.guilds:
#		commands += yield(bot._send_get("/applications/%s/guilds/%s/commands" % [bot.APPLICATION_ID, guild_id]), "completed")


func _on_Add_pressed() -> void:
	commands_container.add_child(command.instance())


func _on_Register_pressed() -> void:
	register()

func register():
	for index in commands.size():
		commands[index] = yield(bot.add_application_commands(commands[index], commands[index].guild_id), "completed")
		commands_container.get_child(index).structure = commands[index]

func set_commands(value: Array):
	commands = value
#	print_debug("added_command")
#	for app_command in commands:
#		var command_node = command.instance()
#		command_node.structure = app_command
#		commands_container.add_child(command_node)

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


