extends Control


onready var tab_container = $TabContainer

func _ready() -> void:
	pass


func _on_TabContainer_tab_changed(tab: int) -> void:
	owner.current_guild_id = tab_container.get_child(tab).guild.id
#	prints(owner.name, owner.current_guild_id)
