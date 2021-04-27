extends Control


onready var field_name_node = $PanelContainer/VBoxContainer/FieldName
onready var field_value_node = $PanelContainer/VBoxContainer/FieldValue
onready var field_inline_node = $PanelContainer/VBoxContainer/InlineButton

var field_name = ""
var field_value = ""
var field_inline = false


func _ready():
	field_name_node.grab_focus()

func _process(_delta):
	field_name = field_name_node.text
	field_value = field_value_node.text
	field_inline = field_inline_node.pressed


func _on_RemoveFieldButton_pressed():
	queue_free()
