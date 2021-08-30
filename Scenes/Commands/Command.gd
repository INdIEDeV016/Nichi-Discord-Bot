extends Control



onready var title = $VBoxContainer/HBoxContainer/Title
onready var panel = $Panel

func _ready() -> void:
	pass


var once: bool
func _on_Title_toggled(button_pressed: bool) -> void:
	if button_pressed:
		GlobalTween.fold_panel(panel, true, 40)
		GlobalTween.make_tween(
			panel, "modulate:a",
			0, 1,
			0.5,
			Tween.TRANS_QUART, Tween.EASE_OUT
		)
		once = false
		title.icon = preload("res://Assets/GuiTreeArrowDown.svg")
	else:
		GlobalTween.fold_panel(self, false, 40)
		GlobalTween.make_tween(
			panel, "modulate:a",
			1, 0,
			0.5,
			Tween.TRANS_QUART, Tween.EASE_OUT
		)
		once = false
		title.icon = preload("res://Assets/GuiTreeArrowRight.svg")


func _on_Name_text_changed(new_text: String) -> void:
	title.text = new_text
