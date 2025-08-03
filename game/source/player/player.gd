class_name Player
extends CharacterBody2D


const TILE_SIZE: int = 16

@export var map_root: Node2D

var ground: TileMapLayer
var upper_ground: TileMapLayer

# Movements
var movement_tween: Tween
var movement_duration: float = 0.2
var is_moving: bool = false

var input_vector: Vector2
var last_input_vector: Vector2
var input_stack: Array[String]

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	if not map_root:
		map_root = get_parent()
	ground = map_root.get_child(0)
	upper_ground = map_root.get_child(1)
	snap_to_grid_map()
	if Global.version_config:
		if ResourceLoader.exists(Global.version_config.get_value("Player", "normal_sprite")):
			swap_textures(load(Global.version_config.get_value("Player", "normal_sprite")))


func _physics_process(_delta: float) -> void:
	input_vector = Vector2.ZERO
	
	# Update stack based on pressed inputs
	update_input_stack()
	
	# Use the last input in the stack if available
	if input_stack.size():
		match input_stack[-1]: # Last item
			"up": input_vector = Vector2.UP
			"down": input_vector = Vector2.DOWN
			"left": input_vector = Vector2.LEFT
			"right": input_vector = Vector2.RIGHT
	
	if not is_moving:
		if input_vector:
			try_to_move(input_vector)
		else:
			set_animation(last_input_vector)


func update_input_stack():
	var directions = {
		"up": Input.is_action_pressed("ui_up"),
		"down": Input.is_action_pressed("ui_down"),
		"left": Input.is_action_pressed("ui_left"),
		"right": Input.is_action_pressed("ui_right")
	}
	
	# Remove any keys no longer pressed
	for key in input_stack.duplicate():
		if !directions.get(key, false):
			input_stack.erase(key)
	
	# Add newly pressed keys
	for key in directions.keys():
		if directions[key] and not input_stack.has(key):
			input_stack.append(key)


func snap_to_grid_map() -> void:
	global_position = ground.local_to_map(global_position) * TILE_SIZE


func try_to_move(direction: Vector2) -> void:
	if last_input_vector != direction:
		last_input_vector = direction
		set_animation(direction)
		return
	
	var wanted_position: Vector2 = position + direction * TILE_SIZE
	var tile_position: Vector2i = ground.local_to_map(wanted_position)
	var tile_data: TileData = upper_ground.get_cell_tile_data(tile_position)
	if tile_data:
		return
	
	is_moving = true
	var target_position: Vector2 = tile_position * TILE_SIZE
	move(target_position)


func move(target_position: Vector2) -> void:
	set_animation(input_vector, "_walk")
	movement_tween = create_tween()
	movement_tween.tween_property(self, "position", target_position, movement_duration)
	movement_tween.finished.connect(_on_movement_finished.bind(input_vector))


func _on_movement_finished(direction: Vector2) -> void:
	is_moving = false
	#if not input_vector:
		#set_animation(direction)


func set_animation(direction: Vector2, state: String = "_idle") -> void:
	if direction.x:
		animated_sprite_2d.play("side" + state)
		animated_sprite_2d.flip_h = direction.x > 0
	elif direction.y > 0:
		animated_sprite_2d.play("down" + state)
	elif direction.y < 0:
		animated_sprite_2d.play("up" + state)


func swap_textures(p_texture: Texture2D) -> void:
	var sprite_frames: SpriteFrames = $AnimatedSprite2D.sprite_frames
	for anim_name in sprite_frames.get_animation_names():
		for i in sprite_frames.get_frame_count(anim_name):
			var texture: AtlasTexture = sprite_frames.get_frame_texture(anim_name, i)
			texture.atlas = p_texture
