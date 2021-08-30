  
class_name Message
"""
Represents a Discord Message
"""

var id: String
var channel_id: String
var guild_id: String
var content: String
var timestamp: String
var edited_timestamp: String
var webhook_id: String
var type: String

var author
var avatar
var member: Dictionary
var activity: Dictionary
var message_reference: Dictionary
var referenced_message: Dictionary

var tts: bool
var mention_everyone: bool
var pinned: bool

var mentions: Array
var mention_roles: Array
var mention_channels: Array
var attachments: Array
var embeds: Array
var reactions: Array
var flags: MessageFlags

var nonce

enum Message_Types {
	DEFAULT
	RECIPIENT_ADD
	RECIPIENT_REMOVE
	CALL
	CHANNEL_NAME_CHANGE
	CHANNEL_ICON_CHANGE
	CHANNEL_PINNED_MESSAGE
	GUILD_MEMBER_JOIN
	USER_PREMIUM_GUILD_SUBSCRIPTION
	USER_PREMIUM_GUILD_SUBSCRIPTION_TIER_1
	USER_PREMIUM_GUILD_SUBSCRIPTION_TIER_2
	USER_PREMIUM_GUILD_SUBSCRIPTION_TIER_3
	CHANNEL_FOLLOW_ADD
	GUILD_DISCOVERY_DISQUALIFIED = 14
	GUILD_DISCOVERY_REQUALIFIED
	GUILD_DISCOVERY_GRACE_PERIOD_INITIAL_WARNING
	GUILD_DISCOVERY_GRACE_PERIOD_FINAL_WARNING
	THREAD_CREATED
	REPLY
	APPLICATION_COMMAND
	THREAD_STARTER_MESSAGE
	GUILD_INVITE_REMINDER
}

func _init(bot, message: Dictionary):
	var user: User
	if message.author is Dictionary:
		user = User.new(bot, message["author"])
	for key in message:
		if key == "author":
			set("author", user)
		if key == "avatar":
			set("avatar", Helpers.to_image_texture(Helpers.to_png_image(yield(user.get_display_avatar({"size": 128}), "completed"))))
		set(key, message[key])
	# Compulsory
#	assert(message.id, 'Message must have an id')
#	if message.has("id") and message.id:
#		id = message.id
#
#	assert(message.has('type'), 'Message must have a type')
#
#	assert(message.has('channel_id') and message.channel_id and Helpers.is_valid_str(message.channel_id), 'Message must have a valid channel_id')
#	channel_id = message.channel_id
#
#	if message.type in Message_Types:
#		type = message.type
#	else:
#		assert(false, 'Message must have a valid type')
#
#	assert(message.has('author'), 'Message must have an author')
#	# Check if the message is sent by webhook
#	if message.has('webhook_id') and Helpers.is_str(message.webhook_id) and message.webhook_id.length() > 0:
#		# webhook sent a message
#		pass
#	else:
#		# sent by user
#		assert(message.author is User, 'author attribute of Mesage must be of type User')
#	author = message.author
#
#	if message.has('flags'):
#		flags = MessageFlags.new(message.flags)
#
##	if message.channel.type != 'DM':
##		assert(message.has('guild_id') and message.guild_id and Helpers.is_valid_str(message.guild_id), 'Message must have a valid guild_id')
##		guild_id = message.guild_id
#
#	if message.has('guild_id') and message.guild_id:
#		guild_id = message.guild_id
#
#	if not message.has('webhook_id'):
#		assert(message.content.length() > 0 or message.embeds.size() > 0 or message.components.size() > 0 or message.attachments.size() > 0, 'Message must have a content or at least one value in (embeds, components or attachments)')
#	content = message.content
#
#	assert(message.timestamp, 'Message must have a timestamp')
#	timestamp = message.timestamp
#
#
#
#	# Optional
#	if message.has('edited_timestamp') and message.edited_timestamp != null:
#		edited_timestamp = message.edited_timestamp
#
#	if message.has('tts'):
#		tts = true if message.tts else false
#
#	if message.has('mention_everyone'):
#		mention_everyone = true if message.mention_everyone else false
#
#	if message.has('mentions') and typeof(message.mentions) == TYPE_ARRAY and message.mentions.size() > 0:
#		mentions = message.mentions
#
#	if message.has('member') and message.member:
#		member = message.member
#	if message.has('mention_roles') and message.mention_roles:
#		mention_roles = message.mention_roles
#	if message.has('mention_channels') and message.mention_channels:
#		mention_channels = message.mention_channels
#	if message.has('attachments') and message.attachments:
#		attachments = message.attachments
#	if message.has('embeds') and message.embeds:
#		embeds = message.embeds
#	if message.has('reactions') and message.reactions:
#		reactions = message.reactions
#	if message.has('pinned') and typeof(message.pinned) == TYPE_BOOL:
#		pinned = message.pinned
#	if message.has('message_reference') and message.message_reference:
#		message_reference = message.message_reference
#	if message.has('referenced_message') and message.referenced_message:
#		referenced_message = message.referenced_message


func _to_string(pretty: bool = false):
	var data = {
		'id': id,
		'channel_id': channel_id,
		'guild_id': guild_id,
		'author': parse_json(author.to_string()),
		'member': member,
		'content': content,
		'timestamp': timestamp,
		'edited_timestamp': edited_timestamp,
		'tts': tts,
		'mention_everyone': mention_everyone,
		'mentions': mentions,
		'mention_roles': mention_roles,
		'mention_channels': mention_channels,
		'attachments': attachments,
		'embeds': embeds,
		'reactions': reactions,
		'pinned': pinned,
		'type': type,
		'message_reference': message_reference,
		'referenced_message': referenced_message,
	}
	
	return JSON.print(data, '\t', true) if pretty else JSON.print(data, '', true)

func print():
	print(_to_string(true))
	return _to_string(true)

func has(attribute):
	return true if self[attribute] else false

func slice_attachments(index: int, delete_count: int = 1, replace_attachments: Array = []):
	var n = attachments.size()
	assert(Helpers.is_num(index), 'index must be provided to Message.slice_attachments')
	assert(index > -1 and index < n, 'index out of bounds in Message.slice_attachments')

	var max_deletable = n - index
	assert(delete_count <= max_deletable, 'delete_count out of bounds in Message.attachments')

	while delete_count != 0:
		attachments.remove(index)
		delete_count -= 1

	if replace_attachments.size() > 0:
		for attachment in replace_attachments:
			assert(attachment.has('id') and Helpers.is_valid_str(attachment.id), 'Missing id for attachment in replace_attachments in slice_attachments')
		attachments.append_array(replace_attachments)

	return self
