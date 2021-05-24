extends Node



# Nichi's Memmory
export (String) var token = "Replace with your own bot token"
export (String) var prefix = "Ni, "
var bot_command_prefix = prefix.to_upper()
var creators_id: String = "615103137304543232"
var bot_id = "820931768852021319"
var default_channel_id = "824634283414782002"
var default_guild_id = "816329865132900352"
var headers := ["Authorization: Bot %s" % token, "Content-Type: application/json"]

onready var Processes = $"../Processes"

var bot_commands = {
	# Question commands
	"WHO ARE YOU":["I am <@!615103137304543232> 's pet bot :wink:. And I love him so much :heart_eyes:!\nHe is the one who brought me to life in this world! :blush:\nAnd also, I am powered by a game engine called Godot Game Engine!\nInteresting isn't it?\nThis is the website of Godot Game Engine...\n https://www.godotengine.org"],
	"ARE YOU THERE":["Yes, I am!"],
	"ARE YOU ALIVE":["Of course, I am.\nYou can see me online, right?:angry:", "Yes my boss <@!{user_id}>"],
	"WHAT CAN YOU DO":["Not much as I am relatively new! Ask my master, <@!615103137304543232>, for the commands that I can understand!"],
	["WHEN IS YOUR BIRTHDAY", "WHEN WERE YOU BORN", "WHAT'S YOUR BIRTHDAY"]:["I was born on 15 March, 2021 and the time being 10:22 AM.\nAlthough, my creator is a male human. :yum:"],
	["WHO CREATED YOU", "WHO IS YOUR CREATOR"]:["<@!615103137304543232> is my creator and I love him so much! :heart_eyes:"],
	# Greeting commands
	"HAO":["Hello! (In Swahili)"],
	["HI","HELLO"]:["Hello <@!{user_id}> :blush:", "Welcome back, <@!{user_id}>, {gratitude}"],
	"GOOD MORNING":["Good Morning :blush:.\nHow do you plan to start your day today?"],
	"GOOD NIGHT":["Good Night, Bye! :blush:\nSweet Dreams! :kissing_heart:"],
	# Emotional commands
	"LOL":["Ha ha! :rofl:"],
	"NOPE":["Obey my master <@!{user_id}, he says NO!"],
	"I LOVE YOU":["Oh, :flushed: uh.. So do I!"],
	"I LIKE YOU":[":star_struck: You are great too! :star_struck:"],
	"PARTY":["Yay! :partying_face:"],
	"ANGRY":[":rage:"],
	"GOOD JOB":["Thank You :blush:"],
	"YOU ARE BAD":["Oh, sorry!\nI didn't mean to hurt your feelings! :cry:"],
	"YOU ARE GOOD":["Thank You!\nEven my master <@!615103137304543232> thinks so! :blush:"],
	# NSFW commands
	["GAAND MARAA", "GAAND MARA", "GAND MARA"]:[":cry::sob:"],
	"GU KHA LE":["Tu gand mara le! :unamused:"],
	"FUCK OFF":["I'll fuck your ass, lil p-p! :rage:"],
	"I WANNA FUCK YOU! YOU ARE SO GOOD!":["Oh, :flushed: umm... but my master <@!615103137304543232>, didn't provide me with holes. :woozy_face:\nI can't eat, drink, pee or poop.\nI do telepathy with Discord to talk to you, that's all!"],
	# URL commands
	
	# Rudimentary commands
	"WHAT HAPPENED":["Nothing I guess", "I want to pee....:confounded:\nhttps://tenor.com/view/cute-tail-wagging-i-have-to-pee-pee-adorable-gif-17357349"],
	"SAY BYE":["Bye Bye! :wave:"],
	"SAY HELLO TO":["Hello"],
	"SHUTDOWN NUCLEOTECH":[".shutdown"],
	}

var links = ["https://c.wallhere.com/photos/ad/28/anime_girls_middle_finger-1375283.jpg!d",
			"https://e7.pngegg.com/pngimages/133/969/png-clipart-asuka-langley-soryu-anime-the-finger-manga-middle-finger-anime-face-manga-thumbnail.png",
			"https://i.pinimg.com/originals/c9/d9/57/c9d9571708e9e09c6adc5ca39f037e04.jpg",
			"https://th.bing.com/th/id/R385d4118f151275f9ce11d349a96d358?rik=JxaEt%2fF3AVF07w&riu=http%3a%2f%2fpm1.narvii.com%2f5751%2fb9e0a59ff763e0e0f61f34fb2166422769f8302c_00.jpg&ehk=AXDimOVkX5EXaDW1p4ShfgirCXdoE9VZOYy2ukpSLP0%3d&risl=&pid=ImgRaw",
			]

var slangs_list: Array = [
	"motherfucker",
	"madarchod",
	"asshole",
	"ass",
	"fuck",
	"saale",
	"sexy",
	" sex ",
	"pee",
	"p-p",
	"gand mara",
	"gaand maraa",
	"bitch",
	"porn",
	"nude",
	" lund ",
	"cumming",
	"cuming",
	"BSDK",
	"Bhosda",
	"Bhosdike",
	"blowjob",
	"cunnilingus",
	"frotage",
	"boob",
	"batla",
	"Chuche",
	"Tits",
	"Tities",
	"rape",
	"Lodu Lalit",
	"Lodu",
	"Lawde",
	"Lodoo",
	"lawda",
	"pussy",
	"cunt",
	"chud",
	"chood",
	"dick",
	"dildo",
	"butt",
]

func _ready():
	randomize()
	var f = File.new()
	if f.file_exists("user://Commands.json"):
		f.open("user://Commands.json", File.READ)
		bot_commands = parse_json(f.get_var(true))
	else:
		f.open("user://Commands.json", File.WRITE)
		f.store_var(JSON.print(bot_commands, "\t", true))
	f.close()

func respond_to(message: String, to: String, guild_id: String, channel_id: String, message_id: String) -> Dictionary:
	var gratitude_list = ["my master", "my hero", "my messiah", "my creator", "my God", "the great"]
	var gratitude = gratitude_list[int(rand_range(0, gratitude_list.size()))]
	
	var error_command = ["Sorry, I didn't get what you meant <@!{user_id}>! :woman_shrugging:", "Sorry, I didn't get what you meant <@!{user_id}>, {gratitude}! :woman_shrugging:"]
	
	var command = message.to_upper()
	var commands_list = bot_commands.keys()
	var main_command = command.replace(bot_command_prefix, "")
	if command.begins_with(bot_command_prefix):
		for item in commands_list:
			if item is String and main_command in item:
				return {"content":bot_commands[item].back().format({"user_id":to, "gratitude":gratitude}) if to == creators_id else bot_commands[item].front().format({"user_id":to, "gratitude":gratitude})}
			elif item is Array and main_command in item:
				return {"content":bot_commands[item].back().format({"user_id":to, "gratitude":gratitude}) if to == creators_id else bot_commands[item].front().format({"user_id":to, "gratitude":gratitude})}
			else:
				continue
		if "GIF " in main_command:
			Processes.get_gif(main_command, channel_id, message_id)
			return {"content":""}
		elif "HELP" in main_command:
			Processes.display_help(main_command, to, channel_id)
			return {}
		elif "DO MATH " in main_command:
			return Processes.calculate_math(main_command)
		elif "SAY HI TO " in main_command:
			return respond_someone(main_command)
		elif "<@!820931768852021319>" in message or main_command.empty():
			return {"content":"Yeah, What? :face_with_raised_eyebrow:"}
		elif "DELETE " in main_command:
			Processes.delete_messages(main_command, channel_id, message_id)
			return {"content":""}
		elif "LEARN " in main_command:
			learn(message)
			return {"content":"OK, I learnt it! :wink:"}
		elif "MUTE " in main_command:
			Processes.mute_user(message, to, guild_id, channel_id)
			return {}
		elif "KICK " in main_command or "BAN " in main_command:
			Processes.kick_ban_user(message, guild_id, channel_id)
			return {}
		elif "PING " in main_command:
			Processes.ping_100(main_command, to, channel_id)
			return {}
		elif "SLANG LIST " in main_command:
			Processes.slang_list_editor(message, to)
			return {}
		return {"content":error_command[int(to == creators_id)].format({"user_id":to, "gratitude":gratitude})}
	else:
		var words: PoolStringArray = message.split(" ", true)
		var slangs: PoolStringArray = []
		for slang in slangs_list:
			slang = slang.to_lower()
			for word in words:
				word = word.to_lower()
#				print("Word: \"%s\" is similar to \"%s\" by %s%%" % [word, slang, word.similarity(slang) * 100])
				if word.similarity(slang) >= 0.68:
#					slangs.append(slang)
					slangs.append(word)
#		prints("Sending slangs:", slangs)
		Processes.slang_smasher(message, to, channel_id, message_id, slangs)
		return {}

func learn(what: String):
	var command = what.replacen("Ni, LEARN ", "")
	var array: PoolStringArray = command.split(":")
	prints("Learning:", array)
	var emoji_modify = [array[1].replace(";", ":")]
	var answer = emoji_modify
	prints(command, answer)
	bot_commands[String(array[0])] = answer
	var f = File.new()
	f.open("user://Commands.json", File.WRITE)
	f.store_var(JSON.print(bot_commands, "\t", true), true)
	f.close()



func respond_someone(to_message: String):
	var id = to_message.replace("SAY HI TO ", "")
	return {"content":"Hi %s :blush:" % id}
