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


func window_tween(window: Control, visible: bool) -> void:
	var transition: int = Tween.TRANS_BACK
	var easing: int = Tween.EASE_OUT
	if visible:
		start_pos = window.get_global_mouse_position()
		window.show()
# warning-ignore:return_value_discarded
		interpolate_property(
			window, "rect_scale",
			Vector2.ZERO, Vector2.ONE,
			window_trans_duration,
			transition, easing
		)
# warning-ignore:return_value_discarded
		interpolate_property(
			window, "rect_position",
			window.get_global_mouse_position(), window.rect_position,
			window_trans_duration,
			transition, easing
		)
# warning-ignore:return_value_discarded
		start()
## warning-ignore:return_value_discarded
#		interpolate_property(
#			window, "rect_size:x",
#			0, size.x,
#			window_trans_duration,
#			transition, easing
#		)
## warning-ignore:return_value_discarded
#		interpolate_property(
#			window, "rect_size:y",
#			window_title_height, size.y,
#			window_trans_duration,
#			transition, easing,
#			window_trans_duration
#		)
## warning-ignore:return_value_discarded
#		start()
#		yield(self, "tween_all_completed")
	else:
		window.show()
# warning-ignore:return_value_discarded
		interpolate_property(
			window, "rect_scale",
			Vector2.ONE, Vector2.ZERO,
			window_trans_duration,
			Tween.TRANS_QUART, easing
		)
# warning-ignore:return_value_discarded
		interpolate_property(
			window, "rect_position",
			window.rect_position, start_pos,
			window_trans_duration,
			transition, easing
		)
# warning-ignore:return_value_discarded
		start()
## warning-ignore:return_value_discarded
#		interpolate_property(
#			window, "rect_size:y",
#			size.y, window_title_height,
#			window_trans_duration,
#			transition, easing
#		)
## warning-ignore:return_value_discarded
#		interpolate_property(
#			window, "rect_size:x",
#			size.x, 0,
#			window_trans_duration,
#			transition, easing,
#			window_trans_duration
#		)
## warning-ignore:return_value_discarded
		yield(self, "tween_all_completed")
		window.hide()
# warning-ignore:return_value_discarded
	yield(self, "tween_all_completed")


func transition_tween(control: Control, visible: bool, color: Color = Color(0.137255, 0.14902, 0.152941)):
	if visible:
#		control.raise()
		control.show()
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
