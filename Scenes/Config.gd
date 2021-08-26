extends Control


var settings: Dictionary = {}
var f = ConfigFile.new()
var file_path: String = "user://Config.cfg"

onready var settings_container = $SettingsContainer


func _ready() -> void:
	f.load(file_path)


func _on_Configure_pressed() -> void:
	for child in settings_container.get_children():
		if not child.get_node("LineEdit").text.empty():
			settings[child.get_node("Label").text] = child.get_node("LineEdit").text
	
	for key in settings:
		if not settings[key].empty():
			f.set_value("Main", key, settings[key])
	f.save(file_path)
	
	f.load(file_path)
	owner.bot_node.login(f.get_value("Main", $SettingsContainer/HBoxContainer/Label.text, ""), f.get_value("Main", $SettingsContainer/HBoxContainer2/Label.text, ""))
	get_parent().current_tab = 2
