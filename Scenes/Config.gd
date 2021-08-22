extends Control


var settings: Dictionary = {}
var f = ConfigFile.new()

onready var settings_container = $SettingsContainer


func _ready() -> void:
	pass


func _on_Configure_pressed() -> void:
	for child in settings_container.get_children():
		settings[child.get_node("Label").text] = child.get_node("LineEdit").text
	
	for key in settings:
		f.set_value("Main", key, settings[key])
	f.save("user://Config.cfg")
	
	owner.discord_bot.login(f.get_value("Main", $SettingsContainer/HBoxContainer/Label.text), f.get_value("Main", $SettingsContainer/HBoxContainer2/Label.text))
