extends MenuButton


func _ready() -> void:
	text = name


func _on_Channel_about_to_show() -> void:
	get_node("../../../../").current_channel = name
	yield(get_tree(), "idle_frame")
	get_popup().rect_global_position.x += rect_size.x
	get_popup().rect_global_position.y -= rect_size.y
