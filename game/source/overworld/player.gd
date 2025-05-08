class_name Player
extends CharacterBody2D

@export var map: Node2D
@onready var ground: TileMapLayer = map.get_child(0)
@onready var upper_ground: TileMapLayer = map.get_child(1)

const TILE_SIZE: int = 16

var movement_delay: float = 0.2 # speed

var movement_tween: Tween
var is_moving: bool = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


var looking_towards: Vector2 = Vector2.ZERO

func _ready() -> void:
	global_position = _fix_position(global_position)

func _fix_position(vec: Vector2):
	return ground.local_to_map(vec) * Vector2i(TILE_SIZE, TILE_SIZE)


func _physics_process(_delta: float) -> void:
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	if input_vector == Vector2.ZERO and not is_moving:
		set_animation(looking_towards)

	var horizontal = input_vector.x
	var vertical = input_vector.y

	if input_vector and not is_moving:
		try_to_move(Vector2(horizontal, 0) if horizontal else Vector2(0, vertical))

func try_to_move(input_vector: Vector2) -> void:
	if input_vector != looking_towards:
		looking_towards = input_vector
		set_animation(looking_towards)
		return
	
	var no_fixed_target_position: Vector2 = position + input_vector * TILE_SIZE
	var tile_local := ground.local_to_map(no_fixed_target_position)
	#TODO handler when chacter exit
	var map_exit = ground.get_cell_tile_data(tile_local) == null
	var collision = upper_ground.get_cell_tile_data(tile_local) != null
	if (collision): return
	
	is_moving = true
	var fixed_target_position: Vector2 = tile_local * Vector2i(TILE_SIZE, TILE_SIZE)
	print(fixed_target_position)
	
	set_animation(input_vector, "_walk")
	movement_tween = create_tween()
	movement_tween.tween_property(self, "position", fixed_target_position, movement_delay)
	movement_tween.finished.connect(func(): is_moving = false)


func set_animation(direction: Vector2, state: String = "") -> void:
	if direction.x:
		animated_sprite_2d.play("side" + state)
		animated_sprite_2d.flip_h = direction.x > 0
	elif direction.y > 0:
		animated_sprite_2d.play("down" + state)
	elif direction.y < 0:
		animated_sprite_2d.play("up" + state)
