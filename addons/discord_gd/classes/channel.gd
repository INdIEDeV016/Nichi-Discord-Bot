class_name Channel

var id: = ''
var type: int
var guild_id: = ''
var position: int
var permission_overwrites: int
var name: = ''
var topic: = ''
var nsfw: bool = false
var last_message_id: = ''
var bitrate: int
var user_limit: int
var rate_limit_per_user: int

enum Channel_Types {
	GUILD_TEXT
	DM
	GUILD_VOICE
	GROUP_DM
	GUILD_CATEGORY
	GUILD_NEWS
	GUILD_STORE
	GUILD_NEWS_THREAD = 10
	GUILD_PUBLIC_THREAD
	GUILD_PRIVATE_THREAD
	GUILD_STAGE_VOICE
}

func _init(channel: Dictionary) -> void:
	for key in channel:
		set(key, channel[key])


static func create_message(bot, payload: Dictionary, channel_id: String):
	print(payload.content) if payload.has("content") and payload.content else print()
#	var payload = {
#		"content": message.content,
#		"tts": message.tts,
#		"file": message.file,
#		"embeds": message.embeds,
#		"payload_json": message.payload_json,
#		"allowed_mentions": message.allowed_mentions,
#		"message_reference": message.message_reference,
#		"components": message.components,
#		"sticker_ids": message.sticker_ids
#	}
	
	return yield(bot._send_request("/channels/%s/messages" % channel_id, payload), "completed")


static func delete_message(bot, message_id: String, channel_id: String):
	return yield(bot._send_request("/channels/%s/messages/%s" % [channel_id, message_id], {}, HTTPClient.METHOD_DELETE), "completed")


static func edit_message(bot, message_id: String, channel_id: String, payload: Dictionary):
#	var payload = {
#		"content": message.content,
#		"embeds": message.embeds,
#		"flags": message.flags,
#		"file": message.file,
#		"payload_json": message.payload_json,
#		"allowed_mentions": message.allowed_mentions,
#		"attachments": message.attachments,
#		"components": message.components
#	}
	
	return yield(bot._send_request("/channels/%s/messages/%s" % [channel_id, message_id], payload, HTTPClient.METHOD_PATCH), "completed")


static func get_message(bot, message_id: String, channel_id: String) -> Message:
	return Message.new(bot, yield(bot._send_get("/channels/%s/messages/%s" % [channel_id, message_id]), "completed"))
		

func get_messages(bot, channel_id: String, before: String = "", limit: int = 100) -> Array:
	var message_array: Array = yield(bot._send_get("/channels/%s/messages" % channel_id + "?limit=%s" % [limit]), "completed")
	
	var message_object_array: Array
	for message in message_array:
		var message_object = Message.new(bot, message)
		message_object_array.append(message_object)
	
	message_object_array = Sorter.new(self, "_sort_message_array", message_object_array, []).get_array()
	
	return message_object_array

static func _sort_message_array(a: Message, b: Message):
	var a_datetime = Helpers.to_datetime(a.timestamp)
	var b_datetime = Helpers.to_datetime(b.timestamp)
	
	if a_datetime.year < b_datetime.year:
		return true
	if a_datetime.year == b_datetime.year and a_datetime.month < b_datetime.month:
		return true
	if a_datetime.year == b_datetime.year and  a_datetime.month == b_datetime.month and a_datetime.day < b_datetime.day:
		return true
	if (a_datetime.year == b_datetime.year and  a_datetime.month == b_datetime.month and 
		a_datetime.day == b_datetime.day and a_datetime.hour < b_datetime.hour):
		return true
	if (a_datetime.year == b_datetime.year and  a_datetime.month == b_datetime.month and 
		a_datetime.day == b_datetime.day and a_datetime.hour == b_datetime.hour and 
		a_datetime.minute < b_datetime.minute):
		return true
	if (a_datetime.year == b_datetime.year and  a_datetime.month == b_datetime.month and 
		a_datetime.day == b_datetime.day and a_datetime.hour == b_datetime.hour and 
		a_datetime.minute == b_datetime.minute and a_datetime.second < b_datetime.second):
		return true
	if (a_datetime.year == b_datetime.year and  a_datetime.month == b_datetime.month and 
		a_datetime.day == b_datetime.day and a_datetime.hour == b_datetime.hour and 
		a_datetime.minute == b_datetime.minute and a_datetime.second == b_datetime.second):
		return true
	return false
				

static func send_typing(bot, channel_id: String):
	return yield(bot._send_request("/channels/%s/typing" % channel_id, {}), "completed")

class Sorter:
	var extra_params = []
	var array
	var object: Object
	var function: String
	
	func _init(_object, _function, _array, _extra_params):
		self.object = _object
		self.function = _function
		self.extra_params = _extra_params
		self.array = _array
		self.array.sort_custom(self, "sort")
	
	func get_array():
		return array
	
	func sort(a, b):
		return object.callv(function, [a, b] + extra_params)
