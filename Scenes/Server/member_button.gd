extends Button


onready var member: Dictionary = {} setget set_member
onready var popup = $PopupMenu


func _ready() -> void:
	pass

func set_member(value: Dictionary) -> void:
	member = value
	name = member.user.id
	hint_tooltip = Helpers.print_dict(member)
	
	if member.has("nick") and member.nick:
		text = member.nick
	else:
		text = member.user.username


func _on_PopupMenu_about_to_show() -> void:
	yield(get_tree(), "idle_frame")
	popup.rect_global_position = Vector2(rect_global_position.x - popup.rect_size.x, rect_global_position.y)


func _on_Member_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT:
			popup.popup()
