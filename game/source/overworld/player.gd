class_name Player
extends CharacterBody2D


const TILE_SIZE: int = 16

var speed: float = 120.0

var movement_tween: Tween
var input_vector: Vector2
var is_moving: bool = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	position = position.snappedf(TILE_SIZE / 2)


#func _unhandled_key_input(_event: InputEvent) -> void:
func _physics_process(delta: float) -> void:
	input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input_vector and not is_moving:
		try_to_move()


func try_to_move() -> void:
	is_moving = true
	#if movement_tween and movement_tween.is_valid():
		#return
	var target_position: Vector2 = (position + input_vector * TILE_SIZE).snappedf(TILE_SIZE)
	set_animation(input_vector, "_walk")
	movement_tween = create_tween()
	movement_tween.tween_property(self, "position", target_position, 0.4)
	movement_tween.finished.connect(foo.bind(input_vector))


func foo(direction: Vector2) -> void:
	is_moving = false
	if not input_vector:
		set_animation(direction)


func set_animation(direction: Vector2, state: String = "") -> void:
	if direction.x:
		animated_sprite_2d.play("side" + state)
		animated_sprite_2d.flip_h = direction.x > 0
	elif direction.y > 0:
		animated_sprite_2d.play("down" + state)
	elif direction.y < 0:
		animated_sprite_2d.play("up" + state)
