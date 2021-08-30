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
		return "%02d:%02d" % [datetime.hour, datetime.minute]
	else:
		if datetime.hour > 12:
			return "%02d:%02d PM" % [datetime.hour - 12, datetime.minute]
		else:
			return "%02d:%02d AM" % [datetime.hour, datetime.minute]

static func get_date(datetime: Dictionary = OS.get_datetime()):
	return "%02d/%02d/%02d" % [datetime.day, datetime.month, datetime.year]

static func to_datetime(iso: String):
	if iso.empty():
		return
	var date = iso.split("T")[0]
	var time = iso.split("T")[1]
	return {
		"year": date.split("-")[0].to_int(), 
		"month": date.split("-")[1].to_int(), 
		"day": date.split("-")[2].to_int(),
		"hour": time.split(":")[0].to_int(),
		"minute": time.split(":")[1].to_int(),
		"second": time.split(":")[2].split(".")[0].to_int(),
		}

static func get_local_time(timestamp: String):
	var time_zone = OS.get_time_zone_info()
	var date_time = to_datetime(timestamp)
	var current_time = OS.get_unix_time_from_datetime(date_time) + time_zone.bias * 60
	return OS.get_datetime_from_unix_time(current_time)

# Pretty prints a Dictionary
static func print_dict(d: Dictionary) -> String:
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
