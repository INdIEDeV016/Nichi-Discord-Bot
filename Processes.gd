extends Node


var event_dict: Dictionary = {"d":{"channel_id":"824634283414782002"}}
var last_sequence: float
var session_id: String

signal httprequest

onready var Memory = $"../Memory"
onready var console = $"../GUI/HSplitContainer/Console"

onready var gif = $"../GIFGetter"

var to = ""

func _ready() -> void:
# warning-ignore:return_value_discarded
	connect("httprequest", self, "make_request")

func handle_events(dict: Dictionary) -> void:
	last_sequence = dict["s"]
	var channel_id = dict["d"].get("channel_id")
	var event_name: String = dict["t"]
	var ignore_event_printing = [
		"GUILD_CREATE",
		"MESSAGE_CREATE",
		"MESSAGE_UPDATE",
		"TYPING_START",
		"CHANNEL_CREATE",
		"CHANNEL_UPDATE",
		"PRESENCE_UPDATE",
	]
	if not event_name in ignore_event_printing:
		print(event_name)
	match event_name:
		"READY":
			session_id = dict["d"]["session_id"]
			var hello_embed: Dictionary = {
				"embed":{
					"color":0x02cb00,
					"title":"Beginning!",
					"description":":smiley: Hello World! :white_sun_small_cloud:\n\nHi <@!{user_id}>! :blush:".format({"user_id":Memory.creators_id}),
					"footer":{
						"text":"BOT_COMING_ONLINE"
					}
				}
			}
#			send_message(hello_embed, Memory.default_channel_id)
		"GUILD_MEMBER_ADD":
			var guild_id = dict["d"]["guild_id"]
			
			var data: Array = yield(make_request("https://discordapp.com/api/v8/guilds/{guild.id}/channels".format({"guild.id":guild_id}), false, HTTPClient.METHOD_GET), "completed")
			var channels = parse_json(data.back().get_string_from_utf8())
#			print(JSON.print(channels, "\t", true))
#			console.text = "\n\n\n" + JSON.print(channels, "\t", true)
			for channel in channels:
				if "WELCOME" in channel["name"].to_upper() or "JOIN" in channel["name"].to_upper():
					channel_id = channel["id"]
					break
			
			var username = dict["d"]["user"]["username"]
			var message_to_send := {"content" : "Welcome %s! :raised_hands:" % username}
			send_message(message_to_send, channel_id)
		"GUILD_MEMBER_REMOVE":
			var guild_id = dict["d"]["guild_id"]
			
			var data: Array = yield(make_request("https://discordapp.com/api/v8/guilds/{guild.id}/channels".format({"guild.id":guild_id}), false, HTTPClient.METHOD_GET), "completed")
			var channels = parse_json(data.back().get_string_from_utf8())
#			print(JSON.print(channels, "\t", true))
#			console.text = "\n\n\n" + JSON.print(channels, "\t", true)
			for channel in channels:
				if not channel is String:
					if "BYE" in channel.get("name").to_upper() or "LEAVE" in channel.get("name").to_upper():
						channel_id = channel["id"]
						break
			
			var username = dict["d"]["user"]["username"]
			var message_to_send := {"content" : "Bye-bye %s! See you soon! :kissing_heart: :wave:" % username}
			send_message(message_to_send, channel_id)
		"GUILD_CREATE":
#			console.text += "\n\n\n" + JSON.print(dict, "\t", true)
			var guild_name = dict["d"]["name"]

			print("GUILD_CREATE (Server: %s)" % guild_name)
		"GUILD_ROLE_CREATE":
			pass
		"GUILD_ROLE_UPDATE":
			var guild_id = dict["d"]["guild_id"]
			print("GUILD_ROLE_UPDATE (Server: %s)" % guild_id)
		"CHANNEL_CREATE":
			print("CHANNEL_CREATE (Server: %s)")
		"CHANNEL_UPDATE":
			var guild_id = dict["d"]["guild_id"]
			print("CHANNEL_UPDATE (Server: %s)" % guild_id)
		"TYPING_START":
#			console.text += "\n\n\n" + JSON.print(dict, "\t", true)
			var user_name = dict["d"]["member"]["user"]["username"]
			var nick = dict["d"]["member"].get("nick")
			var guild_id = dict["d"]["guild_id"]
			print("TYPING_START (by: {user_name}, nick: {nick}, in server: {guild.id})".format({"user_name":user_name, "nick":nick, "guild.id":guild_id}))
		"MESSAGE_CREATE":
			event_dict = dict
			to = dict["d"]["author"]["id"]
			var guild_id = dict["d"]["guild_id"]
			var user_name = dict["d"]["author"]["username"]
			
			var message_content = dict["d"]["content"]
			var message_id = dict["d"]["id"]
			if not message_content.empty():
				print("MESSAGE CREATE (type: Normal by: %s): %s" % [user_name, message_content])
			else:
				prints("MESSAGE CREATE (type: Embed by: %s): %s" % [user_name, JSON.print(dict["d"]["embeds"], "\t", true)], "Content: %s" % message_content)
			var user_id = dict["d"]["author"]["id"]
			var query: Dictionary
			if not dict["d"]["author"]["id"] == Memory.bot_id:
				query = Memory.respond_to(message_content, user_id, guild_id, channel_id, message_id)
			
			
			if not query.empty():
				send_message(query, channel_id)
			console.text += "\n\n\n" + JSON.print(dict, "\t", true)
		"MESSAGE_UPDATE":
			console.text += "\n\n\n" + JSON.print(dict, "\t", true)
			var message_content: String
			var embed_description: String
			var embed_title: String
			if dict["d"].has("content"):
				message_content = dict["d"]["content"]
			
			if dict["d"]["embeds"].empty():
				print("MESSAGE UPDATE (%s): %s" % [dict["d"].get("author").get("username"), message_content])
			else:
				embed_description = dict["d"]["embeds"].front()["description"]
				embed_title = dict["d"]["embeds"].front().get("title")
				print("MESSAGE UPDATE <embed message>", ["Title: %s" % embed_title,"Description: %s" % embed_description])
				
			event_dict = dict
#			to = dict["d"]["author"]["id"]
			var guild_id = dict["d"]["guild_id"]
			
			var message_id = dict["d"]["id"]
			print("MESSAGE CREATE (by: %s): %s" % [dict["d"]["author"]["username"], message_content])
			var user_id = dict["d"]["author"]["id"]
			var query: Dictionary = Memory.respond_to(message_content, user_id, guild_id, channel_id, message_id)
			
			
			if not query.empty():
				send_message(query, channel_id)
		"PRESENCE_UPDATE":
#			print(JSON.print(dict, "\t", true))
#			console.text += "\n\n\n" + JSON.print(dict, "\t", true)
			var user_nickname = dict["d"].get("nick")
			var game_name
			if dict["d"]["game"] != null:
				game_name = dict["d"]["game"].get("name")
			var status = dict["d"].get("status")
			print("PRESENCE_UPDATE (of: {user.nickname}, playing: {game.name}, status: {status})".format({"user.nickname":user_nickname, "game.name":game_name, "status":status}))
			pass



func get_gif(command: String, channel_id: String, _message_id: String):
	var key: String = "E1AC6IL3UDK3"
	var search = command.replacen("GIF ", "").capitalize()
	var amount = 10
	var err = get_node("../GIFGetter").request("https://g.tenor.com/v1/search?key={key}&q={search}&locale=hi_IN&contentfilter=off&limit={limit}".format({"key":key, "search":search, "limit":amount}))
	var data = yield(get_node("../GIFGetter"), "request_completed")
	var response_code = data[1]
	var parse_data = parse_json(data.back().get_string_from_utf8())
#	console.text += "\n\n\n" + JSON.print(parse_data, "\t", true)
#	console.text += "\n\n\n" + JSON.print(data, "\t", true)
	var gif_url: String
	if response_code == 200 and err == 0:
#		for result_dict in parse_data["results"]:
#			urls.append(result_dict["media"].front()["gif"]["url"])
#		gif_url = urls[int(rand_range(0, urls.size()))]
		var result_dict = parse_data["results"][int(rand_range(0, parse_data["results"].size()))]
		gif_url = result_dict["media"].front()["gif"]["url"]
	else:
		gif_url = "Sorry, Couldn't load GIF! :pensive:"
		push_error("Custom Error: Couldn't get GIF!")
	send_message({"content":gif_url}, channel_id)


func display_help(command: String, to: String, channel_id: String):
	var help_embed = {
		"embed":{
			"color":0xfcdb00,
			"title":"Nichi [ni, ] Bot Commands Help Center",
			"description":"Oh, so you wanna know, how I work, then here it is, type any of the commands below to get more info about each the commands",
			"fields":[
				{
					"name":"Delete Messages",
					"value":"`ni, help delete`",
					"inline":true
				},
			],
			"footer":{
				"text":"MAIN_HELP_EMBED"
			}
		}
	}
	send_message(help_embed, channel_id)


func delete_messages(command: String, channel_id: String,  message_id: String):
	var amount: int = int(abs(int(command.replacen("DELETE ", ""))))
	make_request("https://discordapp.com/api/v8/channels/%s/typing" % channel_id, true, HTTPClient.METHOD_POST)
	make_request("https://discordapp.com/api/v8/channels/%s/messages/%s" % [channel_id, message_id], true, HTTPClient.METHOD_DELETE)
	if amount <= 100:
		var channel_messages: Array = yield(make_request("https://discordapp.com/api/v8/channels/{channel_id}/messages?before={message_id_before}&limit={amount}".format({"channel_id":channel_id, "message_id_before":message_id, "amount":amount}), false, HTTPClient.METHOD_GET), "completed")
#		print(JSON.print(parse_json(channel_messages.back().get_string_from_utf8()), "\t", true))
		var messages: Array = parse_json(channel_messages.back().get_string_from_utf8())
		var message_ids: Array = [message_id]
		for message in messages:
			if message is Dictionary:
				message_ids.append(message["id"])
		amount = message_ids.size() - 1
		var data = yield(make_request("https://discordapp.com/api/v8/channels/%s/messages/bulk-delete" % [channel_id], true, HTTPClient.METHOD_POST, JSON.print({"messages":message_ids})), "completed")
#		prints(JSON.print(data, "\t", true), JSON.print(parse_json(data.back().get_string_from_utf8()), "\t", true))
		var delete_embed: Dictionary
		if data[0] == 0 and data[1] == 204:
			
			delete_embed = {
				"embed":{
					"color":0xfcdb00,
					"title":"Deletion Successfull!",
					"description":"I deleted %s message!\nDo you feel the cleanliness now? :blush:" % amount if amount == 1 else "I deleted %s messages!\nDo you feel the cleanliness now? :blush:" % amount,
					"footer":{
						"text":"MESSAGE_DELETE_BULK"
					}
				}
			}
		var no_delete: Dictionary = {
			"embed":{
				"color":0xff0000,
				"title":"Deletion Failed!",
				"description":"What do you want me to delete <@!%s>? :confused:\nThere are no messages here! :woman_shrugging:" % to,
				"footer":{
					"text":"NULL_DELETION"
				}
			}
		}
		make_request("https://discordapp.com/api/v8/channels/%s/messages" % [channel_id], true, HTTPClient.METHOD_POST, JSON.print(delete_embed if amount > 0 else no_delete))
		yield(get_tree().create_timer(2.0), "timeout")
		var last_message = yield(get_last_message(channel_id), "completed")
		make_request("https://discordapp.com/api/v8/channels/%s/messages/%s" % [channel_id, last_message], true, HTTPClient.METHOD_DELETE)


	else:
		var over_amount: Dictionary = {
			"embed":{
				"color":0xff0000,
				"title":":warning: Limit yourself! :warning:",
				"description":"You are deleteing way too many messages at once! :exploding_head:\nDiscord is getting angry with this! :cold_sweat:\nPlease delete maximum 99 messages at once.",
				"footer":{
					"text":"MESSAGE_DELETE_QUERY_OVERFLOW"
				}
			}
		}
		make_request("https://discordapp.com/api/v8/channels/%s/messages" % channel_id, true, HTTPClient.METHOD_POST, JSON.print(over_amount))

func slang_smasher(message: String, to: String, channel_id: String, message_id: String, slangs: PoolStringArray):
	if not slangs.empty():
#		print("checking...")
		var data = yield(make_request("https://discordapp.com/api/v8/channels/%s/messages/%s" % [channel_id, message_id], true, HTTPClient.METHOD_DELETE), "completed")
#		var done = parse_json(data.back().get_string_from_utf8())
#		prints(JSON.print(data, "\t", true), JSON.print(done, "\t", true))
		
		var censored_message: String = message
		for slang in slangs:
#			prints("Replacing slang:", slang)
			var replacement: String = ""
			for i in slang.length():
				replacement += "#"
			if slang.begins_with(" ") and slang.ends_with(" "):
				replacement[0]
			censored_message = censored_message.replacen(slang, replacement)
#		prints("Slang message:", censored_message, slangs)
		if data[0] == 0 and data[1] == 204:
			var slang_alert: Dictionary = {
				"embed":{
					"color":0xff0000,
					"title":":warning: No slangs please! :shushing_face:",
					"description":"Never say that again <@!%s>" % to,
					"fields":[
						{
							"name":"What you said is this:",
							"value":"```%s```" % censored_message
						}
					],
					"footer":{
						"text":"SLANG_ALERT"
					}
				}
			}
			send_message(slang_alert, channel_id)
			var DM_data = yield(make_request("https://discordapp.com/api/v8/users/@me/channels", true, HTTPClient.METHOD_POST, JSON.print({"recipent_id":to})), "completed")
			var DM_channel = parse_json(DM_data.back().get_string_from_utf8())
#			prints(JSON.print(DM_data, "\t", true), JSON.print(DM_channel, "\t", true))
			if DM_data[0] == 0 and DM_data[1] == 200:
				send_message({"content":"Never say \"%s\" anywhere. These are bad words!" % slangs.join(", ")})

func slang_list_editor(slang_message: String, to: String):
	var slang_edit_command: Array = slang_message.replacen("ni, ", "").split(":")
	prints("Slang Edit Command:", slang_edit_command)
	if slang_edit_command.front().to_lower() == "remove" and slang_edit_command.back() in Memory.slangs_list:
		Memory.slangs_list.remove(Memory.slangs_list.find(slang_edit_command.back()))
	elif slang_edit_command.front().to_lower() == "add" and not slang_edit_command.back() in Memory.slangs_list:
		Memory.slangs_list.append(slang_edit_command.back())
	print(Memory.slangs_list)

func _on_SleepButton_pressed():
	sleep()

func calculate_math(command):
	var math: String = command.replacen("DO MATH ", "").replacen("x", "*").replace(" ", "")
	print(math)
	var expression = Expression.new()
	var error = expression.parse(math, [])
	if error != OK:
		return {"content":"Your math was hard to understand :confused:\nThis is the error: %s" % expression.get_error_text()}
	var result = expression.execute([], Node)
	if not expression.has_execute_failed():
		print(result)
		return {"content":"It's {math}".format({"math":result})}

func make_request(link: String, ssl_validation: bool = true, method: int = 0, content:String = "", headers:PoolStringArray = ["Authorization: Bot %s" % Memory.token, "Content-Type: application/json"]):
	var http = HTTPRequest.new()
	http.download_chunk_size = 16384
	http.use_threads = true
	get_node("../HTTPRequests").add_child(http)
	var err
	err = http.request(link, headers, ssl_validation, method, content)
	var data = yield(http, "request_completed") #await
	var response_code = data[1]
#	prints(response_code, ":", JSON.print(parse_json(data.back().get_string_from_utf8()), "\t", true))
# warning-ignore:standalone_ternary
# warning-ignore:standalone_ternary
	http.queue_free() if err == OK else push_error("Custom Error: Something bad happened while requesting!")
	return data


func get_last_message(channel_id: String):
	var last_message: Array = yield(make_request("https://discordapp.com/api/v8/channels/%s" % [channel_id], true, HTTPClient.METHOD_GET), "completed")
	return parse_json(last_message.back().get_string_from_utf8())["last_message_id"]

func send_message(content: Dictionary, channel_id: String = "824634283414782002"):
	emit_signal("httprequest", "https://discordapp.com/api/v8/channels/%s/messages" % channel_id, true, HTTPClient.METHOD_POST, JSON.print(content))

func mute_user(command: String, _to: String, guild_id: String, channel_id: String, _message_id: String = ""):
	var header: = ["Authorization: Bot %s" % Memory.token, "Content-Type: application/json", "Content-Length: 0"]
	var mute = not "NI, UNMUTE" in command.to_upper()
	var user_data: PoolStringArray = command.replacen("Ni, MutE ", "").replacen("ni, unmute ", "").split(":")
	var user_id = user_data[0].replace("<", "").replace("@", "").replace("!", "").replace(">", "").replace(" ", "")
	
#	var to_user_info_data = yield(make_request("https://discordapp.com/api/v8/guilds/{guild.id}/members/{user.id}".format({"guild.id":guild_id, "user.id":to}), false, HTTPClient.METHOD_GET), "completed")
#	var to_user_info = parse_json(to_user_info_data.back().get_string_from_utf8())
#	print(JSON.print(to_user_info, "\t", true))
	
	var reason: = "Not given"
	var data: Array
	var roles_data = yield(make_request("https://discordapp.com/api/v8/guilds/{guild.id}/roles".format({"guild.id":guild_id}), false, HTTPClient.METHOD_GET), "completed")
	var roles = parse_json(roles_data.back().get_string_from_utf8())
#	print(JSON.print(roles, "\t", true))
	var muted_role_id
	for role in roles:
		if role["name"] == "Muted":
			muted_role_id = role["id"]
			break
	if mute:
		prints("Mute command:", user_data, user_id)
		data = yield(make_request("https://discordapp.com/api/v8/guilds/{guild.id}/members/{user.id}/roles/{role.id}".format({"guild.id":guild_id, "user.id":user_id, "role.id":muted_role_id}), false, HTTPClient.METHOD_PUT, "", header), "completed")
	else:
		prints("Unmute command:", user_data, user_id)
		data = yield(make_request("https://discordapp.com/api/v8/guilds/{guild.id}/members/{user.id}/roles/{role.id}".format({"guild.id":guild_id, "user.id":user_id, "role.id":muted_role_id}), false, HTTPClient.METHOD_DELETE), "completed")
	if not user_data.size() == 1: reason = user_data[1]
	console.text += "\n\n\n" + JSON.print(data, "\t", true)
	var mute_embed = {
		"embed":{
			"color":0xfcdb00,
			"title":":shushing_face: Mute :shushing_face:" if mute else ":rolling_eyes: Unmute :rolling_eyes:",
			"description":"Muted <@!%s>! The fathead!" % user_id if mute else "Fine :rolling_eyes:, you are unmuted <@!%s>" % user_id,
			"fields":[{
				"name":"Reason",
				"value":reason
			}],
			"footer":{
				"text":"MUTE_SUCCESS" if mute else "UNMUTE_SUCCESS"
			}
		}
	}
	var failed_embed = {
		"embed":{
			"color":0xff0000,
			"title":":shushing_face: Mute :shushing_face:" if mute else ":rolling_eyes: Unmute :rolling_eyes:",
			"description":"Sorry! Couldn't mute <@!%s>! They are at a higher post than me, I guess! :pensive:" % user_id if mute else "Oh no, can't unmute <@!%s>!" % user_id,
			"footer":{
				"text":"MUTE_FAILED" if mute else "UNMUTE_FAILED"
			}
		}
	}
	var parse_data
	print(parse_data)
	if data[0] == 0 and data[1] == 204:
#		parse_data = JSON.print(parse_json(data.back().get_string_from_utf8()), "\t", true)
# warning-ignore:standalone_ternary
		send_message(mute_embed, channel_id) if data[1] == 204 else send_message(failed_embed, channel_id)
	else:
# warning-ignore:standalone_ternary
		parse_data = JSON.print(parse_json(data.back().get_string_from_utf8()), "\t", true)
		send_message(failed_embed, channel_id) if data[1] == 204 else send_message(failed_embed, channel_id)

func kick_ban_user(command: String, guild_id: String, channel_id: String, message_id: String = ""):
	var header: = ["Authorization: Bot %s" % Memory.token, "Content-Type: application/json", "Content-Length: 0"]
	var kick: bool = "NI, KICK " in command.to_upper()
	var user_data: PoolStringArray = command.replacen("Ni, KICK ", "").replacen("ni, ban ", "").split(":")
	var user_id = user_data[0].replace("<", "").replace("@", "").replace("!", "").replace(">", "").replace(" ", "")
	var reason: = "Not given"
	var data: Array
	var deletion = yield(make_request("https://discordapp.com/api/v8/channels/{channel.id}/messages/{message.id}".format({"channel.id":channel_id, "message.id":message_id}), false, HTTPClient.METHOD_DELETE), "completed")
	print(deletion)
	if kick:
		prints("Kick Command:", user_data, user_id)
		data = yield(make_request("https://discordapp.com/api/v8/guilds/{guild.id}/members/{user.id}".format({"guild.id":guild_id, "user.id":user_id}), false, HTTPClient.METHOD_DELETE), "completed")
	else:
		prints("Ban Command:", user_data, user_id)
		data = yield(make_request("https://discordapp.com/api/v8/guilds/{guild.id}/bans/{user.id}".format({"guild.id":guild_id, "user.id":user_id}), false, HTTPClient.METHOD_PUT, JSON.print({"delete_message_days":7}), header), "completed")
	prints(JSON.print(data, "\t", true))
	if not user_data.size() == 1: reason = user_data[1]
	var kick_embed = {
		"embed":{
			"color":0xfcdb00,
			"title":":leg: Kick :leg:" if kick else ":door: Ban :door:",
			"description":"Alright, kicked <@!%s> from this server!" % user_id if kick else "Banned the traitor called <@!%s> from this server, huh!\nNow we may have peace, ig! :relieved:" % user_id,
			"fields":[{
				"name":"Reason:",
				"value":reason
			}],
			"footer":{
				"text":"KICK_SUCCESS" if kick else "BAN_SUCCESS"
			}
		}
	}
	var failed_embed = {
		"embed":{
			"color":0xff0000,
			"title":":leg: Kick :leg:" if kick else ":door: Ban :door:",
			"description":"<@!%s> is as hard as an iron pillar, can't kick them! :pensive:" % user_id if kick else "Maybe, let's make peace with <@!%s> because, I am unable to ban them! :blush:" % user_id,
			"fields":[
				{
					"name":"Reason:",
					"value":reason
				}
			],
			"footer":{
				"text":"KICK_FAILED" if kick else "BAN_FAILED"
			}
		}
	}
	var parse_data
	print(parse_data)
	if data[0] == 0 and data[1] == 204:
# warning-ignore:standalone_ternary
		send_message(kick_embed, channel_id) if data[1] == 204 else send_message(failed_embed, channel_id)
	else:
# warning-ignore:standalone_ternary
		send_message(failed_embed, channel_id) if data[1] == 204 else send_message(failed_embed, channel_id)
	parse_data = JSON.print(parse_json(data.back().get_string_from_utf8()), "\t", true)

func ping_100(command: String, to: String, channel_id: String):
	if to == Memory.creators_id:
		var who: String = command.replacen("Ping ", "")
		for i in 100:
			send_message({"content":who}, channel_id)
			yield(get_tree().create_timer(1.5), "timeout")
	else:
		var failed_embed = {
			"embed":{
				"color":0xff0000,
				"title":"Ping Faliure!",
				"description":"Only my ~~dad~~Creator <@!%s> can ping someone" % Memory.creators_id,
				"footer":{
					"text":"PINGING_FAILED"
				}
			}
		}
		send_message(failed_embed, channel_id)

func sleep() -> void:
	var channel_id = Memory.default_channel_id
	if event_dict != null:
		channel_id = event_dict["d"]["channel_id"]
	var sleep_text = {
						"embed":{
									"color":0xff0000,
									"title":":warning: Warning :warning:",
									"description":"I wanna go to bed! Bye! :yawning_face:\nSee you later! :wave:",
									"footer":{
												"text":"BOT_GOING_OFFLINE",
											}
								}
					}
	yield(make_request("https://discordapp.com/api/v8/channels/%s/messages" % channel_id, true, HTTPClient.METHOD_POST, JSON.print(sleep_text)), "completed")
	get_tree().quit()

#func events(event: Dictionary, ctx: Dictionary):
#	if event["s"] == "MESSAGE CREATE":
#		execute_bot_command(ctx["content"])
#	elif event["s"] == "MESSAGE UPDATE":
#		execute_bot_command(ctx["content"])
