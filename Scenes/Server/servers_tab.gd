extends Control


onready var tab_container = $TabContainer


func _ready() -> void:
	get_parent().set_tab_disabled(get_index(), true)

func _on_TabContainer_tab_changed(tab: int) -> void:
	owner.current_guild_id = tab_container.get_child(tab).guild.id
#	prints(owner.name, owner.current_guild_id)


func _on_DiscordBot_bot_ready(bot) -> void:
	get_parent().set_tab_disabled(get_index(), false)
