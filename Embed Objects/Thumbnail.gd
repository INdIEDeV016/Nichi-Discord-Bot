extends Control


onready var thumbnail_url_node = $VBoxContainer/Url
onready var thumbnail_proxyurl_node = $VBoxContainer/ProxyUrl
onready var thumbnail_width_node = $VBoxContainer/HBoxContainer/Width
onready var thumbnail_height_node = $VBoxContainer/HBoxContainer/Height

var thumbnail_url = ""
var thumbnail_proxyurl = ""
var thumbnail_width = 800
var thumbnail_height = 800


func _process(_delta):
	thumbnail_url = thumbnail_url_node.text
	thumbnail_proxyurl = thumbnail_proxyurl_node.text
	thumbnail_height = int(thumbnail_height_node.text)
	thumbnail_width = int(thumbnail_width_node.text)
