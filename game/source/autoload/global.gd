extends Node


#signal level_changed()

var version_cfg: ConfigFile
var version: String = "FireRed"

var item_index: Dictionary


func _ready() -> void:
	load_item_index()
	tree_exiting.connect(_on_tree_exiting)


func _on_tree_exiting() -> void:
	pass


func load_item_index() -> void:
	var file: FileAccess = FileAccess.open("res://assets/sprites/items/icons/item_icons_index.json", FileAccess.READ)
	if file:
		var parsed_data = JSON.parse_string(file.get_as_text())
		if typeof(parsed_data) == TYPE_DICTIONARY:
			item_index = parsed_data
