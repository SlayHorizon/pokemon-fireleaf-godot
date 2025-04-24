extends Sprite2D


const TALL_GRASS_EFFECT: PackedScene = preload("uid://ih7viwxxdle5")

enum GrassState {
	NORMAL,
	STEPPED
}

var effect: AnimatedSprite2D


func _ready() -> void:
	frame = GrassState.NORMAL


func _on_entity_entered() -> void:
	frame = GrassState.STEPPED
	play_effect()


func _on_entity_existed() -> void:
	frame = GrassState.NORMAL


func play_effect() -> void:
	if not effect:
		effect = TALL_GRASS_EFFECT.instantiate()
		add_child(effect)
	effect.frame = 0
	effect.play(&"default")


func _on_area_2d_body_entered(body: Node2D) -> void:
	_on_entity_entered()


func _on_area_2d_body_exited(body: Node2D) -> void:
	_on_entity_existed()
