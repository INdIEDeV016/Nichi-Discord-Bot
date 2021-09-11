extends Button


var channel: Dictionary = {} setget set_channel

onready var popup = $PopupMenu


func _ready() -> void:
	get_parent().move_child(self, channel.position + 2)
	yield(get_tree(), "idle_frame")


func set_channel(value: Dictionary):
	channel = value
	name = channel.id

	if channel.type == Channel.Channel_Types.GUILD_CATEGORY:
		flat = true
		icon = preload("res://Assets/GuiTreeArrowRight.svg")
	elif channel.type == Channel.Channel_Types.GUILD_VOICE:
		disabled = true
		icon = preload("res://Assets/Voice Channel.svg")
	elif channel.type == Channel.Channel_Types.GUILD_STAGE_VOICE:
		icon = preload("res://Assets/Stage Channel.svg")

	text = channel.name
	var dict = channel
	hint_tooltip = Helpers.print_dict(dict)


func _on_PopupMenu_about_to_show() -> void:
	get_node("..").owner.current_channel = name
	yield(get_tree(), "idle_frame")
	popup.rect_global_position = Vector2(rect_global_position.x + rect_size.x, rect_global_position.y)


func _on_Channel_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT and event.pressed:
			popup.call_deferred("popup")
#			popup.show()

func arrange():
	if channel.has("parent_id"):
		pass


func _on_PopupMenu_id_pressed(id: int) -> void:
	pass # Replace with function body.


func _on_Channel_pressed() -> void:
	if channel.type == Channel.Channel_Types.GUILD_TEXT:
		get_parent().owner.current_channel = channel.id
