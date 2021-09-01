extends VBoxContainer



onready var title = $Title
onready var panel = $Panel


func _ready() -> void:
	panel.self_modulate = Color(0.211765, 0.223529, 0.247059)


func _process(delta: float) -> void:
	if is_zero_approx(panel.rect_scale.y):
		panel.hide()
	else:
		panel.show()


func _on_Title_toggled(button_pressed: bool) -> void:
	if button_pressed:
		title.icon = preload("res://Assets/GuiTreeArrowDown.svg")
		GlobalTween.fold_panel(panel, true)
		GlobalTween.make_tween(
			panel, "modulate:a",
			0, 1,
			0.5,
			Tween.TRANS_QUART, Tween.EASE_OUT
		)
	else:
		title.icon = preload("res://Assets/GuiTreeArrowRight.svg")
		GlobalTween.fold_panel(panel, false)
		GlobalTween.make_tween(
			panel, "modulate:a",
			1, 0,
			0.5,
			Tween.TRANS_QUART, Tween.EASE_OUT
		)


func _on_Name_text_changed(new_text: String) -> void:
	title.text = new_text if not new_text.empty() else "Name"


func _on_Panel_mouse_entered() -> void:
	panel.self_modulate = Color(0.211765, 0.223529, 0.247059)


func _on_Panel_mouse_exited() -> void:
	panel.self_modulate = Color(0.211765, 0.223529, 0.247059)
