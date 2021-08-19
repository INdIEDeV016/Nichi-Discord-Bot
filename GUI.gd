extends Control


onready var users = $HSplitContainer/ScrollContainer/VBoxContainer/CustomMessagePanel/VBoxContainer/HBoxContainer/MenuButton
onready var custom_message = $HSplitContainer/ScrollContainer/VBoxContainer/CustomMessagePanel/VBoxContainer/TextEdit
onready var embed_users = $HSplitContainer/ScrollContainer/VBoxContainer/EmbedPanel/VBoxContainer/HBoxContainer5/MenuButton2
onready var embed_title_node = $HSplitContainer/ScrollContainer/VBoxContainer/EmbedPanel/VBoxContainer/EmbedTitle
onready var embed_description_node = $HSplitContainer/ScrollContainer/VBoxContainer/EmbedPanel/VBoxContainer/EmbedDescription
onready var field_container = $HSplitContainer/ScrollContainer/VBoxContainer/EmbedPanel/VBoxContainer/Fields

onready var embed_footer = $HSplitContainer/ScrollContainer/VBoxContainer/EmbedPanel/VBoxContainer/TabContainer/Footer
onready var embed_image = $HSplitContainer/ScrollContainer/VBoxContainer/EmbedPanel/VBoxContainer/TabContainer/Image
onready var embed_video = $HSplitContainer/ScrollContainer/VBoxContainer/EmbedPanel/VBoxContainer/TabContainer/Video
onready var embed_thumbnail = $HSplitContainer/ScrollContainer/VBoxContainer/EmbedPanel/VBoxContainer/TabContainer/Thumbnail
onready var embed_provider = $HSplitContainer/ScrollContainer/VBoxContainer/EmbedPanel/VBoxContainer/TabContainer/Provider
onready var embed_author = $HSplitContainer/ScrollContainer/VBoxContainer/EmbedPanel/VBoxContainer/TabContainer/Author

onready var embed_preview = $"../CanvasLayer/EmbedPreviewHandler/EmbedPreview/ScrollContainer"

var embed_title = ""
var embed_description = ""

onready var Memory = $"../Memory"
onready var Processes = $"../Processes"

func _ready():
	users.get_popup().connect("index_pressed", self, "_on_MenuButton_item_focused", [users])
	embed_users.get_popup().connect("index_pressed", self, "_on_MenuButton2_item_focused", [embed_users])
	
# warning-ignore:return_value_discarded
	$"HSplitContainer/ScrollContainer/VBoxContainer/EmbedPanel/VBoxContainer/TabContainer/Thumbnail/VBoxContainer/Url".connect("focus_exited", embed_preview, "set_image", [$"HSplitContainer/ScrollContainer/VBoxContainer/EmbedPanel/VBoxContainer/TabContainer/Thumbnail/VBoxContainer/Url", "thumbnail"])
# warning-ignore:return_value_discarded
	$"HSplitContainer/ScrollContainer/VBoxContainer/EmbedPanel/VBoxContainer/TabContainer/Image/VBoxContainer/Url".connect("focus_exited", embed_preview, "set_image", [$"HSplitContainer/ScrollContainer/VBoxContainer/EmbedPanel/VBoxContainer/TabContainer/Image/VBoxContainer/Url", "image"])
# warning-ignore:return_value_discarded
	$"HSplitContainer/ScrollContainer/VBoxContainer/EmbedPanel/VBoxContainer/TabContainer/Author/VBoxContainer/Name".connect("text_changed", embed_preview, "set_data", ["author"])
# warning-ignore:return_value_discarded
	$"HSplitContainer/ScrollContainer/VBoxContainer/EmbedPanel/VBoxContainer/TabContainer/Footer/VBoxContainer/Text".connect("text_changed", embed_preview, "set_data", ["footer"])
# warning-ignore:return_value_discarded
	$"HSplitContainer/ScrollContainer/VBoxContainer/EmbedPanel/VBoxContainer/EmbedTitle".connect("text_changed", embed_preview, "set_data", ["title"])
# warning-ignore:return_value_discarded
	$"HSplitContainer/ScrollContainer/VBoxContainer/EmbedPanel/VBoxContainer/EmbedDescription".connect("text_changed", embed_preview, "set_data", [$"HSplitContainer/ScrollContainer/VBoxContainer/EmbedPanel/VBoxContainer/EmbedDescription", "description"])

func _process(_delta):
	embed_description = embed_description_node.text
	embed_title = embed_title_node.text
	
	

func _on_MenuButton_item_focused(index, button):
	custom_message.text += mentions_manager(index, button)


func _on_MenuButton2_item_focused(index, button):
	embed_description_node.text += mentions_manager(index, button)

func mentions_manager(index: int, button: Object) -> String:
	var item = button.get_popup().get_item_text(index)
	var format = " <@!%s>"
	match item:
		"Silent Creator":
			return format % "512231386699137027"
		"Major Sardine":
			return format % "455260456500723712"
		"INdIE DeV":
			return format % "615103137304543232"
		"NucleoBot":
			return format % "816332062302535761"
	return format % ""

func _on_SendButton_pressed():
	Processes.send_message({"content":custom_message.text}, Processes.event_dict["d"]["channel_id"])
	custom_message.text = ""


func _on_SendEmbedButton_pressed():
	Processes.send_message(construct_embed(),Processes.event_dict["d"]["channel_id"])
	clear_text()

func clear_text():
	embed_title = ""
	embed_description = ""
	embed_footer.footer_text = ""


func _on_AddFieldButton_pressed():
	var field = preload("res://Embed Objects/Fields.tscn").instance()
	field_container.add_child(field, true)

func construct_embed():
	var embed = {
			"embed":{
				"color":0xfcdb00,
				"title":embed_title,
				"description":embed_description,
				"fields":[
				
				],
				"footer":{
					"text":embed_footer.footer_text,
					"icon_url":embed_footer.footer_url,
					"proxy_icon_url":embed_footer.footer_proxyurl,
				},
				"provider":{
					"name":embed_provider.provider_name,
					"url":embed_provider.provider_url,
				},
				"author":{
					"name":embed_author.author_name,
					"url":embed_author.author_url,
					"icon_url":embed_author.author_icon_url,
					"proxy_icon_url":embed_author.author_icon_proxyurl,
				},
				"image":{
					"url":embed_image.image_url,
					"proxy_url":embed_image.image_proxyurl,
					"height":embed_image.image_height,
					"width":embed_image.image_width,
				},
				"video":{
					"url":embed_video.video_url,
					"proxy_url":embed_video.video_proxyurl,
					"height":embed_video.video_height,
					"width":embed_video.video_width,
				},
				"thumbnail":{
					"url":embed_thumbnail.thumbnail_url,
					"proxy_url":embed_thumbnail.thumbnail_proxyurl,
					"height":embed_thumbnail.thumbnail_height,
					"width":embed_thumbnail.thumbnail_width,
				}
			}
		}
	var fields = field_container.get_children()
	for field in fields:
		embed["embed"]["fields"].append({
			"name":field.field_name,
			"value":field.field_value,
			"inline":field.field_inline,
		})
	return embed
