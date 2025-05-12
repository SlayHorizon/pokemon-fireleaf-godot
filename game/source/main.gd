extends Node


const TITLE_SCREEN: PackedScene = preload("res://source/title_screen/title_screen.tscn")

## Specify a default configuration path if no custom configuration was found.
## Will use FireRed configuration by default if empty.
@export_file("*.cfg") var firered_default_config_path: String = ""
@export_file("*.cfg") var leafgreen_default_config_path: String = ""

@export var skip_config_menu: bool = false


func _ready() -> void:
	var arguments: Dictionary = parse_cmdline_args()
	var config_argument: String = arguments.get("config", "")
	
	if config_argument:
		var config_path: String = get_config_path(config_argument)
		if not config_path:
			printerr("Custom config path not found with config argument: %s." % config_argument)
			return
		var button := Button.new()
		button.text = config_argument
		button.add_theme_font_override("font", load("res://assets/fonts/pokemon-firered-leafgreen-font.otf"))
		button.add_theme_font_size_override("font_size", 10)
		button.pressed.connect(
			func() -> void:
				print("Custom config path from cmd line used: %s." % config_path)
				set_config(config_path)
				get_tree().change_scene_to_packed.call_deferred(TITLE_SCREEN)
		)
		$Control/VBoxContainer/VBoxContainer/GridContainer.add_child(button)


func parse_cmdline_args() -> Dictionary:
	var arguments: Dictionary = {}
	for argument: String in OS.get_cmdline_args():
		if argument.contains("="):
			var key_value: PackedStringArray = argument.split("=")
			arguments[key_value[0].trim_prefix("--")] = key_value[1]
		else:
			arguments[argument.trim_prefix("--")] = ""
	return arguments


func get_config_path(config_name: String) -> String:
	var dir: DirAccess = DirAccess.open("res://data/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				if file_name.begins_with(config_name) and file_name.ends_with(".cfg"):
					dir.list_dir_end()
					return "res://data/" + file_name
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		printerr("An error occurred when trying to access res://data/ directory")
	return ""


func set_config(config_path: String) -> bool:
	var config_file: ConfigFile = ConfigFile.new()
	var error: Error = config_file.load(config_path)
	if error:
		printerr("Failed to load config file at %s." % config_path)
		return false
	Global.version_config = config_file
	Global.version_name = config_file.get_value("Info", "version_name", "Unknown")
	return true


func _on_fire_red_button_pressed() -> void:
	if firered_default_config_path:
		set_config(firered_default_config_path)
	get_tree().change_scene_to_packed.call_deferred(TITLE_SCREEN)


func _on_leaf_green_button_pressed() -> void:
	if leafgreen_default_config_path:
		set_config(leafgreen_default_config_path)
	get_tree().change_scene_to_packed.call_deferred(TITLE_SCREEN)


func _on_open_file_dialog_button_pressed() -> void:
	var file_dialog: FileDialog = FileDialog.new()
	
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.root_subfolder = "data/"
	file_dialog.filters = PackedStringArray(["*.cfg"])
	file_dialog.use_native_dialog = true
	
	file_dialog.file_selected.connect(
		func(path: String) -> void:
			set_config(path)
			file_dialog.queue_free()
			get_tree().change_scene_to_packed.call_deferred(TITLE_SCREEN)
	)
	
	add_child(file_dialog)
	
	file_dialog.show()
