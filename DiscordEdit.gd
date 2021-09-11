extends Control
class_name DiscordEdit, "res://Assets/TextEdit.svg"


signal button_pressed(button)
signal text_entered(text)
signal size_changed(value)

export(int) var max_visible_lines: int = 5
export(String, MULTILINE) var text: String
export(String) var placeholder_text: String
export var bottom_margin: int = 8

onready var container = $PanelContainer/HBoxContainer
onready var add_button = $PanelContainer/HBoxContainer/AttachFileButton
onready var main_text = $PanelContainer/HBoxContainer/TextEdit
onready var placeholder = $PanelContainer/HBoxContainer/TextEdit/Placeholder
onready var gif_button = $PanelContainer/HBoxContainer/GIFButton
onready var sticker_button = $PanelContainer/HBoxContainer/StickerButton
onready var emoji_button = $PanelContainer/HBoxContainer/EmojiButton

onready var height: float



func _ready() -> void:
	main_text.center_viewport_to_cursor()
	adjust_text_nodes()
	placeholder.text = placeholder_text
	main_text.text = text

	for button in $PanelContainer/HBoxContainer.get_children():
		if button is TextureButton:
			button.connect("pressed", self, "button_clicked", [button])


func adjust_text_nodes():
	text = main_text.text
#	var text_height: float = main_text.get_font("font", "TextEdit").get_wordwrap_string_size(main_text.text, main_text.rect_size.x).y
	var total_lines: int = main_text.get_line_count()
	var line_height: int = get_constant("line_spacing", "TextEdit") + get_font("font", "TextEdit").height
	height = line_height * total_lines + (bottom_margin * 2)
#	print(height)

	var old_height: float = rect_min_size.y

	if rect_min_size.y < line_height * max_visible_lines + (bottom_margin * 2):
		rect_min_size.y = height

	if rect_min_size.y == old_height:
		rect_min_size.y += rect_min_size.y - old_height


	rect_position.y -= rect_min_size.y - old_height
	emit_signal("size_changed", rect_min_size.y - old_height)

	if main_text.text.empty():
		placeholder.show()
	else:
		placeholder.hide()

	if rect_min_size.y > height:
		rect_position.y += line_height
		rect_min_size.y -= line_height



func _on_TextEdit_text_changed() -> void:
	adjust_text_nodes()


func _on_TextEdit_cursor_changed() -> void:
	adjust_text_nodes()


func button_clicked(button: TextureButton) -> void:
	emit_signal("button_pressed", button)


func _on_TextEdit_gui_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.scancode == KEY_ENTER and event.shift == false and not event.echo:
			emit_signal("text_entered", text)
			main_text.text = ""
