extends Control


onready var author_name_node = $VBoxContainer/Name
onready var author_url_node = $VBoxContainer/Url
onready var author_icon_url_node = $VBoxContainer/IconUrl
onready var author_icon_proxyurl_node = $VBoxContainer/ProxyIconUrl

var author_name = ""
var author_url = ""
var author_icon_url = ""
var author_icon_proxyurl = ""

func _process(_delta):
	author_name = author_name_node.text
	author_url = author_url_node.text
	author_icon_url = author_icon_url_node.text
	author_icon_proxyurl = author_icon_proxyurl_node.text
