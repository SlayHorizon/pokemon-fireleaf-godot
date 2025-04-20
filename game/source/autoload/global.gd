extends Node


var version_cfg: ConfigFile
var version: String = "FireRed"


func _ready() -> void:
	tree_exiting.connect(_on_tree_exiting)


func _on_tree_exiting() -> void:
	pass
