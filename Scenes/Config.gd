extends Control


var settings: Dictionary = {}
var f = ConfigFile.new()
var file_path: String = "user://config.cfg"

onready var settings_container = $SettingsContainer


func _ready() -> void:
	f.load(file_path)
	for key in f.get_section_keys("Main"):
		var refined_key = key.replace(":", "")
		settings[refined_key] = f.get_value("Main", key)


func _on_Configure_pressed() -> void:
#	yield(settings_container, "ready")
	for child in settings_container.get_children():
		if child.get_child_count():
			if child.get_child(1) is LineEdit and not child.get_node("LineEdit").text.empty():
				settings[child.get_node("Label").text.rstrip(":")] = child.get_node("LineEdit").text
			if child.get_child(1) is CheckBox:
				settings[child.get_node("Label").text.rstrip(":")] = child.get_node("CheckBox").pressed
			if child.get_child(1) is OptionButton:
				settings[child.get_node("Label").text.rstrip(":")] = child.get_node("OptionButton").text.to_lower()
	print(settings)
	for key in settings:
		if settings[key]:
			print(key)
			f.set_value("Main", key, settings[key])
	f.save(file_path)
	
	f.load(file_path)
	owner.bot_node.INTENTS = settings.Intents if settings.has("Intents") else 32383
	print(f.get_value("Main", $SettingsContainer/HBoxContainer/Label.text.rstrip(":"), "failing"))
	print(f.get_section_keys("Main"))
	owner.bot_node.login(f.get_value("Main", $SettingsContainer/HBoxContainer/Label.text.rstrip(":"), ""), f.get_value("Main", $SettingsContainer/HBoxContainer2/Label.text, ""))
	owner.bot_node.set_presence({
		"status": settings.Status if settings.has("Status") else "idle",
		"afk": settings.AFK if settings.has("AFK") else false,
		"activity": {
			"type": settings.Type if settings.has("Type") else "listening",
			"name": settings.Name if settings.has("Name") else "you. Please be sane!",
		}
	})
	get_parent().current_tab = 2
