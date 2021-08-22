extends MarginContainer

var avatar: ImageTexture
var author_name: String
var content: String
var time: String

onready var discord_edit = $HBoxContainer/VBoxContainer/MarginContainer2/DiscordEdit


func _ready():
	$HBoxContainer/MarginContainer/Avatar.texture = avatar
	$HBoxContainer/VBoxContainer/MarginContainer/HBoxContainer/Name.text = author_name
	$HBoxContainer/VBoxContainer/MarginContainer/HBoxContainer/Time.text = time
	$HBoxContainer/VBoxContainer/MarginContainer2/Content.text = content
	
	$HBoxContainer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$Button.get_popup().connect("id_pressed", self, "_id_pressed")

func edit():
	$HBoxContainer/VBoxContainer/MarginContainer2/Content.hide()
	discord_edit.show()
	discord_edit.main_text.text = "test cool"
	$HBoxContainer/VBoxContainer/MarginContainer2/DiscordEdit.adjust_text_nodes()
	discord_edit.grab_focus()
	
	

func _id_pressed(id: int):
	match id:
		0:
			# reply
			pass
		1:
			# edit
			edit()
			$HBoxContainer.mouse_filter = Control.MOUSE_FILTER_STOP
		3:
			# delete
			pass
		5:
			# copy id
			pass
