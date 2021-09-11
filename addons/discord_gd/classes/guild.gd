#extends Object
class_name Guild

var id: String
var name: String


var icon: String
var icon_hash: String
var splash: String
var discovery_splash: String
var owner_id: String
var permissions: String
var afk_channel_id: String
var widget_channel_id: String
var application_id: String
var system_channel_id: String
var rules_channel_id: String
var joined_at: String

var afk_timeout: int
var verification_level: int
var default_message_notifications: int
var explicit_content_filter: int
var mfa_level: int
var system_channel_flags: int
var member_count: int

var owner: bool
var widget_enabled: bool
var large: bool
var available: bool

var roles: Array
var emojis: Array
var features: Array
var voice_states: Array
var members: Array
var channels: Array
var threads: Array
var presences: Array

var channels_dict: Dictionary
func _init(guild: Dictionary) -> void:
	for property in guild:
		set(property, guild[property])

	for channel in channels:
		channels_dict[channel.id] = channel


func get_channels(bot) -> Array:
	return yield(bot._send_get("/guilds/%s/channels" % id), "completed")

func get_channel(bot, channel_id):
	var channel = yield(bot._send_get("/channels/%s" % channel_id), "completed")
	return Channel.new(channel)


func get_members(bot, limit: int = 1000, after: int = 0) -> Array:
	var members: Array = yield(bot._send_get("/guilds/%s/members" % id + "?limit=%d&after=%d" % [limit, after]), "completed")

	for member in members:
		member.user = User.new(bot, member.user)
	return members
