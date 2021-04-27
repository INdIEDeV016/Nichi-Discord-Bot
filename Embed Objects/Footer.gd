extends Control


onready var footer_text_node = $VBoxContainer/Text
onready var footer_url_node = $VBoxContainer/Url
onready var footer_proxyurl_node = $VBoxContainer/ProxyUrl

var footer_text = ""
var footer_url = ""
var footer_proxyurl = ""

func _process(_delta):
	footer_text = footer_text_node.text
	footer_url = footer_url_node.text
	footer_proxyurl = footer_proxyurl_node.text
