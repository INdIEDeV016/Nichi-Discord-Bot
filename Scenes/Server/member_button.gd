extends Button


onready var member = {} setget set_member
onready var popup = $PopupMenu


func _ready() -> void:
	rect_scale = Vector2.ZERO
	GlobalTween.make_tween(
		self, "rect_scale",
		Vector2.ZERO, Vector2.ONE,
		0.5,
		Tween.TRANS_BACK, Tween.EASE_OUT
	)


func set_member(value: Dictionary) -> void:
	member = value.duplicate()
	name = member.user.id
	hint_tooltip = Helpers.print_dict(member)
	
	if member.has("nick") and member.nick:
		text = member.nick
	else:
		text = member.user.username
	print(member, "cool")


func _on_PopupMenu_about_to_show() -> void:
	yield(get_tree(), "idle_frame")
	popup.rect_global_position = Vector2(rect_global_position.x - popup.rect_size.x, rect_global_position.y)


func _on_Member_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT:
			popup.popup()


func _on_PopupMenu_id_pressed(id):
	match id:
		0:
			# copy
			print(member, "testing") # this is empty dict for no reason?
			OS.set_clipboard(member.user.id)
