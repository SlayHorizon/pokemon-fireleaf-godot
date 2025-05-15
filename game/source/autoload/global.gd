extends Node


#signal level_changed()

var version_config: ConfigFile
var version_name: String = "FireRed"

var item_index: Dictionary

var music_player: AudioStreamPlayer


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


func play_music(music: AudioStream) -> void:
	if not music:
		return
	if not music_player:
		music_player = AudioStreamPlayer.new()
		music_player.volume_db = -32.0
		add_child(music_player)
	music_player.stream = music
	music_player.play()
