extends Control


onready var video_url_node = $VBoxContainer/Url
onready var video_proxyurl_node = $VBoxContainer/ProxyUrl
onready var video_width_node = $VBoxContainer/HBoxContainer/Width
onready var video_height_node = $VBoxContainer/HBoxContainer/Height

var video_url = ""
var video_proxyurl = ""
var video_width = 800
var video_height = 800


func _process(_delta):
	video_url = video_url_node.text
	video_proxyurl = video_proxyurl_node.text
	video_height = int(video_height_node.text)
	video_width = int(video_width_node.text)
