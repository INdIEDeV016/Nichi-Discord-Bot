extends MenuButton


func _ready() -> void:
	text = name
	
	


func _on_Member_about_to_show() -> void:
	yield(get_tree(), "idle_frame")
	get_popup().rect_global_position -= Vector2(rect_size.x, rect_size.y)
