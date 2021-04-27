extends ScrollContainer


onready var thumbnail = $MarginContainer/VBoxContainer/HBoxContainer/PanelContainer3/Thumbnail
onready var image = $MarginContainer/VBoxContainer/PanelContainer2/Image
onready var author = $MarginContainer/VBoxContainer/Author
onready var footer = $MarginContainer/VBoxContainer/Footer
onready var title = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Title
onready var description = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Description

onready var Processes = $"../../../../Processes"
onready var Memory = $"../../../../Memory"


func set_image(url_line_edit: LineEdit, what: String):
	var data = yield(get_image(url_line_edit.text), "completed")
	var body = data.back()
	if data is Array and not url_line_edit.text.empty():
		match what:
			"thumbnail":
				var raw_image = Image.new()
				var error = raw_image.load_png_from_buffer(body)
				if error != OK:
					push_error("Couldn't load the image.")
				
				var texture = ImageTexture.new()
				texture.create_from_image(raw_image)
				
				 # Display the image in a TextureRect node.
# warning-ignore:standalone_ternary
				thumbnail.get_parent().show() if not url_line_edit.text.empty() else thumbnail.get_parent().hide()
				thumbnail.texture = texture
			"image":
				var raw_image = Image.new()
				var error = raw_image.load_png_from_buffer(body)
				if error != OK:
					push_error("Couldn't load the image.")
				
				var texture = ImageTexture.new()
				texture.create_from_image(raw_image)
				
				 # Display the image in a TextureRect node.
# warning-ignore:standalone_ternary
				image.get_parent().show() if not url_line_edit.text.empty() else image.get_parent().hide()
				image.texture = texture
	else:
		push_error("Image load error: Couldn't load image")

func get_image(url: String):
	var http = HTTPRequest.new()
	http.download_chunk_size = 65536
	http.use_threads = true
	get_node("../../../../HTTPRequests").add_child(http, true)
	var err = http.request(url, PoolStringArray(), false, HTTPClient.METHOD_GET)
	var data = yield(http, "request_completed") #await
#	var response_code = data[1]
#	print(response_code, " :", JSON.print(parse_json(data.back().get_string_from_utf8())))
# warning-ignore:standalone_ternary
	http.queue_free() if err == OK else push_error("Custom Error: Something bad happened while requesting!")
	return data


func set_data(text, in_what: String):
	if text is String:
		match in_what:
			"author":
				author.text = text
			"footer":
				footer.text = text
			"title":
				title.text = text
	elif text is TextEdit and in_what == "description":
		description.text = text.text
