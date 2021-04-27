extends Control


onready var image_url_node = $VBoxContainer/Url
onready var image_proxyurl_node = $VBoxContainer/ProxyUrl
onready var image_width_node = $VBoxContainer/HBoxContainer/Width
onready var image_height_node = $VBoxContainer/HBoxContainer/Height

var image_url = ""
var image_proxyurl = ""
var image_width = 800
var image_height = 800


func _process(_delta):
	image_url = image_url_node.text
	image_proxyurl = image_proxyurl_node.text
	image_height = int(image_height_node.text)
	image_width = int(image_width_node.text)
