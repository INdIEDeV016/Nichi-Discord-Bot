class_name Helpers
"""
General purpose Helpers functions
used by discord.gd plugin
"""

# Returns true if value is an int or real float
static func is_num(value) -> bool:
	return value is int or value is float


# Returns true if value is a string
static func is_str(value) -> bool:
	return value is String


# Returns true if the string has more than 1 character
static func is_valid_str(value) -> bool:
	return is_str(value) and value.length() > 0


# Return a ISO 8601 timestamp as a String
static func make_iso_string(datetime: Dictionary = OS.get_datetime(true)) -> String:
	var iso_string = '%s-%02d-%02dT%02d:%02d:%02d' % [datetime.year, datetime.month, datetime.day, datetime.hour, datetime.minute, datetime.second]

	return iso_string

static func get_time(datetime: Dictionary = OS.get_datetime(), airport_time: bool = false):
	if airport_time:
		return "%0d:%0d" % [datetime.hour, datetime.minute]
	else:
		if datetime.hour > 12:
			return "%0d:%0d PM" % [datetime.hour - 12, datetime.minute]
		else:
			return "%0d:%0d AM" % [datetime.hour, datetime.minute]

# Pretty prints a Dictionary
static func print_dict(d) -> String:
#	print(JSON.print(d, '\t'))
	return JSON.print(d, '\t', true)


# Saves a Dictionary to a file for debugging large dictionaries
static func save_dict(d: Dictionary, filename = 'saved_dict') -> void:
	assert(typeof(d) == TYPE_DICTIONARY, 'type of d is not Dictionary in save_dict')
	var file = File.new()
	file.open('user://%s%s.json' % [filename, str(OS.get_ticks_msec())], File.WRITE)
	file.store_string(JSON.print(d, '\t'))
	file.close()
	print('Dictionary saved to file')


# Converts a raw image bytes to a png Image
static func to_png_image(bytes: PoolByteArray) -> Image:
	var image = Image.new()
	image.load_png_from_buffer(bytes)
	return image


# Converts a Image to ImageTexture
static func to_image_texture(image: Image) -> ImageTexture:
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	return texture
