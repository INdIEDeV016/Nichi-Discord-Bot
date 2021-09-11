extends PanelContainer


var structure: Dictionary = {
	"name": "name",
	"value": "value"
} setget set_structure

func _ready() -> void:
	get_parent().owner.get_parent().owner.structure.options[get_parent().owner.get_index()].choices.append(structure)


func _on_Name_text_changed(new_text: String) -> void:
	self.structure.name = new_text.to_lower()


func _on_Description_text_changed(new_text: String) -> void:
	self.structure.value = new_text


func _on_Delete_pressed() -> void:
	get_parent().owner.get_parent().owner.structure.options[get_parent().owner.get_index()].choices.remove(get_index())
	queue_free()


func set_structure(value: Dictionary):
	structure = value

	get_parent().owner.get_parent().owner.structure.options[get_parent().owner.get_index()].choices[get_index()] = structure
