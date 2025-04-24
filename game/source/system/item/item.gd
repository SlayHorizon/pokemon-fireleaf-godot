@tool
class_name Item
extends Resource


static var icon_index: Dictionary = {}:
	get = _get_icon_index

@export var item_name: StringName = &"acro_bike"
@export var icon_spritesheet: Texture2D = preload("res://assets/sprites/items/icons/item_icons.png")
@export var custom_icon_index: int = -1


func _init() -> void:
	if icon_index.is_empty():
		load_item_index()


static func _get_icon_index() -> Dictionary:
	if icon_index.is_empty():
		load_item_index()
	return icon_index


# Only called once when the game starts,
# not sure if it's the best place to write this function.
static func load_item_index() -> void:
	var file: FileAccess = FileAccess.open("res://assets/sprites/items/icons/item_icons_index.json", FileAccess.READ)
	if file:
		var parsed_data = JSON.parse_string(file.get_as_text())
		if typeof(parsed_data) == TYPE_DICTIONARY:
			icon_index = parsed_data


# Virtual function
func use_item() -> void:
	pass
