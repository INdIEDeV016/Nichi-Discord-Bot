extends Node




#make sure to actually replace this with your token!
var tenor_token = "E1AC6IL3UDK3"
var client : WebSocketClient
var last_sequence : float
var session_id : String
var heartbeat_interval : float
var heartbeat_ack_received := true
var invalid_session_is_resumable : bool
var event_dict

onready var http = $HTTPRequest
onready var console = $GUI/HSplitContainer/Console
onready var http_gif = $GIFGetter


onready var Memory = $Memory
onready var Processes = $Processes
 
signal event
signal sleep

func _ready() -> void:
	randomize()
	client = WebSocketClient.new()
# warning-ignore:return_value_discarded
	client.connect_to_url("wss://gateway.discord.gg/?v=6&encoding=json")
# warning-ignore:return_value_discarded
	client.connect("connection_established", self, "_connection_established")
# warning-ignore:return_value_discarded
	client.connect("connection_closed", self, "_connection_closed")
# warning-ignore:return_value_discarded
	client.connect("server_close_request", self, "_server_close_request")
# warning-ignore:return_value_discarded
	client.connect("data_received", self, "_data_received")
	
# warning-ignore:return_value_discarded
	connect("event", Processes, "handle_events")
# warning-ignore:return_value_discarded
	connect("sleep", Processes, "sleep")
 
func _process(_delta : float) -> void:
	#check if the client is not disconnected, there's no point to poll it if it is
	if client.get_connection_status() != NetworkedMultiplayerPeer.CONNECTION_DISCONNECTED:
		client.poll()
	else:
		#If it is disconnected, try to resume
# warning-ignore:return_value_discarded
		client.connect_to_url("wss://gateway.discord.gg/?v=8&encoding=json")
 
func _connection_established(protocol : String) -> void:
	print("We are connected! Protocol: %s" % protocol)
 
func _connection_closed(was_clean_close : bool) -> void:
	print("We disconnected. Clean close: %s" % was_clean_close)
 
func _server_close_request(code : int, reason : String) -> void:
	print("The server requested a clean close of code %s because %s" % [code, reason])
 
func _data_received() -> void:
	var packet := client.get_peer(1).get_packet()
	var data := packet.get_string_from_utf8()
	var json_parsed := JSON.parse(data)
	var dict : Dictionary = json_parsed.result
	var op = str(dict["op"]) #convert it to string for easier checking
	match op:
		"0": #Opcode 0 Dispatch (Events)
			print("Dispatch")
			emit_signal("event", dict)
		"9": #Opcode 9 Invalid Session
			print("Invalid Session")
			invalid_session_is_resumable = dict["d"]
			$InvalidSessionTimer.one_shot = true
			$InvalidSessionTimer.wait_time = rand_range(1, 5)
			$InvalidSessionTimer.start()
		"10": #Opcode 10 Hello
			print("Hello")
			#Set our timer
			heartbeat_interval = dict["d"]["heartbeat_interval"] / 1000
			print("Hearbeat Interval: %s seconds" % heartbeat_interval)
			$HeartbeatTimer.wait_time = heartbeat_interval
			$HeartbeatTimer.start()
 
			var d := {}
			if !session_id:
				#Send Opcode 2 Identify to the Gateway
				d = {
					"op" : 2,
					"d" : {
						"token" : Memory.token,
						"properties" : {}
					}
				}
			else:
				#Send Opcode 6 Resume to the Gateway
				d = {
					"op" : 6,
					"d" : { "token" : Memory.token, "session_id" : session_id, "seq" : last_sequence}
				}
			send_dictionary_as_packet(d)
		"11": #Opcode 11 Heartbeat ACK
			heartbeat_ack_received = true
			print("We've received a Heartbeat ACK from the gateway.")
 
 
func _on_HeartbeatTimer_timeout() -> void: #Send Opcode 1 Heartbeat payloads every heartbeat_interval
	if !heartbeat_ack_received:
		#We haven't received a Heartbeat ACK back, so we'll disconnect
		client.disconnect_from_host(1002)
		return
	var d := {"op" : 1, "d" : last_sequence}
	send_dictionary_as_packet(d)
	heartbeat_ack_received = false
	print("We've send a Heartbeat to the gateway.")
 
func send_dictionary_as_packet(d : Dictionary) -> void:
	var query = to_json(d)
	# warning-ignore:return_value_discarded
	client.get_peer(1).put_packet(query.to_utf8())

 
func _on_InvalidSessionTimer_timeout() -> void:
	var d := {}
	if invalid_session_is_resumable && session_id:
		#Send Opcode 6 Resume to the Gateway
		d = {
			"op" : 6,
			"d" : { "token" : Memory.token, "session_id" : session_id, "seq" : last_sequence}
		}
	else:
		#Send Opcode 2 Identify to the Gateway
		d = {
			"op" : 2,
			"d" : { "token" : Memory.token, "properties" : {} }
		}
	send_dictionary_as_packet(d)

func _notification(what):
	if what == NOTIFICATION_WM_QUIT_REQUEST:
		emit_signal("sleep")
