extends Tween


var window_trans_duration: = 0.3
var window_title_height = 40
var transition_duration = 0.8
var start_pos: Vector2

func make_tween(
	object: Control,
	param_path: NodePath,
	from, to,
	duration: float,
	tween_transition: int, tween_easing: int,
	delay: float = 0
) -> void:
# warning-ignore:return_value_discarded
	interpolate_property(
		object,
		param_path,
		from, to,
		duration,
		tween_transition, tween_easing,
		delay
	)
# warning-ignore:return_value_discarded
	start()
	yield(self, "tween_all_completed")


func fold_panel(control: Control, visible: bool, folded_size: float = 0) -> void:
	if visible:
# warning-ignore:return_value_discarded
		interpolate_property(
			control, "rect_min_size:y",
			folded_size, control.rect_size.y,
			0.5,
			Tween.TRANS_QUART, Tween.EASE_OUT
		)
# warning-ignore:return_value_discarded
		interpolate_property(
			control, "rect_scale:y",
			0, 1,
			0.5,
			Tween.TRANS_QUART, Tween.EASE_OUT
		)
	else:
# warning-ignore:return_value_discarded
		interpolate_property(
			control, "rect_min_size:y",
			control.rect_size.y, folded_size,
			0.5,
			Tween.TRANS_QUART, Tween.EASE_OUT
		)
# warning-ignore:return_value_discarded
		interpolate_property(
			control, "rect_scale:y",
			1, 0,
			0.5,
			Tween.TRANS_QUART, Tween.EASE_OUT
		)
# warning-ignore:return_value_discarded
	start()
	yield(self, "tween_all_completed")


func transition_tween(control: Control, visible: bool, color: Color = Color(0.137255, 0.14902, 0.152941)):
	if visible:
#		control.raise()
		control.show()
# warning-ignore:return_value_discarded
		interpolate_property(
			control, "modulate",
			Color.transparent, color,
			transition_duration,
			Tween.TRANS_QUART, Tween.EASE_OUT
		)
# warning-ignore:return_value_discarded
		start()
		yield(self, "tween_all_completed")
	else:
# warning-ignore:return_value_discarded
		interpolate_property(
			control, "modulate",
			control.modulate, Color.transparent,
			transition_duration,
			Tween.TRANS_QUART, Tween.EASE_OUT
		)
# warning-ignore:return_value_discarded
		start()
		yield(self, "tween_all_completed")
		control.hide()


static func is_adult(node: Node):
	return node.get_children().size() as bool
