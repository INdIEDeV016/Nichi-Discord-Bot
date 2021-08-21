extends Control


onready var text = $TextEdit


func _ready() -> void:
	pass


func _on_Clear_pressed() -> void:
	text.text = ""
