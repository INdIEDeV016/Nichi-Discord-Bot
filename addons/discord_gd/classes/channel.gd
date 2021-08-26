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


static func get_message(bot, message_id: String, channel_id: String) -> Dictionary:
	return Message.new(bot, yield(bot._send_get("/channels/%s/messages/%s" % [channel_id, message_id]), "completed"))
		

static func get_messages(bot, channel_id: String, before: String) -> Array:
	var message_array: Array = yield(bot._send_get("/channels/%s/messages" % channel_id + "?before=%s" % before), "completed")
	
#	var message_object_array: Array
#	for message in message_array:
#		var message_object = Message.new(message)
#		message_object_array.append(message_object)
	var invert = message_array # PLEASE REPORT: Array.invert() is not working, it returns `Nil`
	return invert
