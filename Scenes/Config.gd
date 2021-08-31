extends Control


var settings: Dictionary = {}
var f = ConfigFile.new()
var file_path: String = "user://config.cfg"

onready var settings_container = $SettingsContainer

var statuses = {
	"invisible": "offline", # exception
	"dnd": "dnd",
	"online": "online",
	"idle": "idle",
	"offline": "offline",
	"do not disturb": "dnd" # exception
}

func _ready() -> void:
	f.load(file_path)
	for key in f.get_section_keys("Main"):
		var refined_key = key.replace(":", "")
		settings[refined_key] = f.get_value("Main", key)
	
#	print(settings)
	settings["Name"] = "you. Please be sane."
	for child in settings_container.get_children():
		if child.get_child_count():
#			print(child.get_node("Label").text.rstrip(":"))
#			print(settings[child.get_node("Label").text.rstrip(":")])
			if child.get_child(1) is LineEdit:
				
				child.get_node("LineEdit").text = settings[child.get_node("Label").text.rstrip(":")]
			if child.get_child(1) is CheckBox:
				child.get_node("CheckBox").pressed = settings[child.get_node("Label").text.rstrip(":")]
			if child.get_child(1) is OptionButton:
#				print(settings[child.get_node("Label").text.rstrip(":")])
#				print(find_selected_from_id(child.get_node("OptionButton"), settings[child.get_node("Label").text.rstrip(":")]))
				child.get_node("OptionButton").selected = find_selected_from_id(child.get_node("OptionButton"), settings[child.get_node("Label").text.rstrip(":")])

func find_selected_from_id(button: OptionButton, text: String):
	for index in button.get_item_count():
		var ind_text = button.get_item_text(index)
		if ind_text.to_lower() == text.to_lower():
			return index
	return -1

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
	for key in settings:
		if settings[key]:
			f.set_value("Main", key, settings[key])
	f.save(file_path)
	
	f.load(file_path)
	owner.bot_node.INTENTS = settings.Intents if settings.has("Intents") else 32383
	print(f.get_value("Main", $SettingsContainer/HBoxContainer/Label.text.rstrip(":"), "failing"))
	print(f.get_section_keys("Main"))
	owner.bot_node.set_presence({
		"status": statuses[settings.Status.to_lower() if settings.has("Status") else "idle"],
		"afk": settings.AFK if settings.has("AFK") else false,
		"activity": {
			"type": settings.Type if settings.has("Type") else "listening",
			"name": settings.Name if settings.has("Name") else "you. Please be sane!",
		}
	})
	get_parent().current_tab = 2
