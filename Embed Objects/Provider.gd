extends Control


onready var provider_name_node = $VBoxContainer/Name
onready var provider_url_node = $VBoxContainer/Url


var provider_name = ""
var provider_url = ""


func _process(_delta):
	provider_name = provider_name_node.text
	provider_url = provider_url_node.text
