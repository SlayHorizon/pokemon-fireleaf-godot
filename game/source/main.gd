extends Node


func _ready() -> void:
	var arguments: Dictionary = {}
	for argument: String in OS.get_cmdline_args():
		if argument.contains("="):
			var key_value: PackedStringArray = argument.split("=")
			arguments[key_value[0].trim_prefix("--")] = key_value[1]
		else:
			arguments[argument.trim_prefix("--")] = ""
	var version_name: String = arguments.get("version", "")
	if version_name:
		var config_path: String = get_version_config_file(version_name)
		Global.version_cfg = ConfigFile.new()
		Global.version_cfg.load(config_path)
		Global.version = version_name

	get_tree().change_scene_to_file.call_deferred("res://source/title_screen/title_screen.tscn")


func get_version_config_file(version_name: String) -> String:
	var dir: DirAccess = DirAccess.open("res://data/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				if file_name.begins_with(version_name) and file_name.ends_with(".cfg"):
					return "res://data/" + file_name
			file_name = dir.get_next()
	else:
		printerr("An error occurred when trying to access the path.")
	return ""
