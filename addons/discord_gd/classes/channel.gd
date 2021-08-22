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

func _init(channel: Dictionary) -> void:
	for property in channel:
		set(property, channel[property])

func send(bot: DiscordBot, content: String = String(), embed: Embed = null, options: Dictionary = Dictionary()):
	print(content)
	var payload = {
		"content": content,
		"files": []
	}
	if embed:
		payload["embed"] = embed.to_string()
	return bot._send_request("/channels/%s/messages" % id, payload)
