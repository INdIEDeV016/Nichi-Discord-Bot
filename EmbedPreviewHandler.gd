extends Control


onready var tween = $"../../Tween"
onready var preview_button = $PreviewButton


var once: bool = false
func _on_PreviewButton_pressed():
	if not once:
		show_preview_panel()
		once = true
	else:
		hide_preview_panel()
		once = false


func show_preview_panel():
	preview_button.text = "<<"
	tween.interpolate_property(
		self, "rect_position",
		self.rect_position, Vector2.ZERO,
		0.5, Tween.TRANS_BACK, Tween.EASE_OUT
	)
	tween.start()

func hide_preview_panel():
	preview_button.text = ">>"
	tween.interpolate_property(
		self, "rect_position",
		self.rect_position, Vector2(-self.rect_size.x, 0),
		0.5, Tween.TRANS_BACK, Tween.EASE_IN
	)
	tween.start()
