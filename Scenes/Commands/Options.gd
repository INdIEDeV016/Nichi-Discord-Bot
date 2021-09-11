extends PanelContainer


const choice = preload("res://Scenes/Commands/Choices.tscn")

var structure: Dictionary = {
	"name": "name",
	"type":3,
	"description": "description",
	"choices": [],
	"required":false
} setget set_structure

onready var choices_container = $VBoxContainer/ChoicesContainer

func _ready() -> void:
	get_parent().owner.structure.options.append(structure)


func _on_OptionButton_item_selected(index: int) -> void:
	self.structure.type = index + 1


func _on_CheckBox_toggled(button_pressed: bool) -> void:
	self.structure.required = button_pressed


func _on_OptionName_text_changed(new_text: String) -> void:
	self.structure.name = new_text.to_lower()


func _on_OptionDescription_text_changed(new_text: String) -> void:
	self.structure.description = new_text


func _on_Delete_pressed() -> void:
	get_parent().owner.structure.options.remove(get_index())
	queue_free()


func _on_Add_pressed() -> void:
	choices_container.add_child(choice.instance())


func set_structure(value: Dictionary):
	structure = value

	get_parent().owner.structure.options[get_index()] = structure
