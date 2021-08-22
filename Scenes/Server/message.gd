extends MarginContainer

var avatar: ImageTexture
var author_name: String
var content: String
var time: String

func _ready():
	$HBoxContainer/MarginContainer/Avatar.texture = avatar
	$HBoxContainer/VBoxContainer/MarginContainer/HBoxContainer/Name.text = author_name
	$HBoxContainer/VBoxContainer/MarginContainer/HBoxContainer/Time.text = time
	$HBoxContainer/VBoxContainer/MarginContainer2/Content.text = content

