class_name EnvironmentArea
extends Area2D


@export var music: AudioStream
@export var meteo: String


func _ready() -> void:
	#body_entered.connect(_on_body_entered)
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		Global.play_music(music)
