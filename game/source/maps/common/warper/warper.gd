@tool
class_name Warper
extends Area2D


const DIRECTION_MAP: Dictionary = {
	Direction.LEFT: Vector2.LEFT,
	Direction.RIGHT: Vector2.RIGHT,
	Direction.UP: Vector2.UP,
	Direction.DOWN: Vector2.DOWN,
}

enum Direction {LEFT, RIGHT, UP, DOWN}

@export var target: Warper:
	set = _set_target
@export var exit_direction: Direction = Direction.DOWN:
	set = _set_exit_direction

var can_teleport: bool = true


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	if target:
		body_entered.connect(_on_area_body_entered)
		body_exited.connect(_on_area_body_exited)


func _draw() -> void:
	if Engine.is_editor_hint():
		if target:
			draw_line(Vector2.ZERO, target.global_position - global_position, Color.RED, 1.0)
		var dir: Vector2 = DIRECTION_MAP.get(exit_direction)
		draw_line(Vector2.ZERO, dir * 8, Color(Color.CADET_BLUE, 0.8), 1.5)
		draw_colored_polygon(
			PackedVector2Array([
				dir * 16,
				dir * 8 + Vector2(dir.y * 5, dir.x * 5),
				dir * 8 + -Vector2(dir.y * 5, dir.x * 5),
			]),
			Color(Color.CADET_BLUE, 0.8)
		)


func _notification(what: int) -> void:
	if Engine.is_editor_hint():
		if what == NOTIFICATION_TRANSFORM_CHANGED and target:
			queue_redraw()
			target.queue_redraw()


func warp_player(player: Player) -> void:
	can_teleport = false
	player.global_position = global_position - Vector2(8, 8)
	var direction: Vector2
	match exit_direction:
		Direction.LEFT:
			direction = Vector2.LEFT
		Direction.RIGHT:
			direction = Vector2.RIGHT
		Direction.UP:
			direction = Vector2.UP
		Direction.DOWN:
			direction = Vector2.DOWN
	var target_position: Vector2 = (player.global_position + direction * 16).snappedf(16)
	var tween: Tween = create_tween()
	tween.tween_property(player, "global_position", target_position, 0.4)
	await tween.finished
	player.set_physics_process(true)


func _set_target(_target: Warper) -> void:
	if _target == target:
		return
	if _target == null:
		if target:
			# Avoid recursion
			_target = target
			target = null
			_target.target = null
		target = null
	else:
		target = _target
		_target.target = self
	queue_redraw()


func _set_exit_direction(value: Direction) -> void:
	exit_direction = value
	queue_redraw()


func _on_area_body_entered(body: Node2D) -> void:
	if not can_teleport or body is not Player:
		return
	body.set_physics_process(false)
	if body.movement_tween and body.movement_tween.is_valid():
		await body.movement_tween.finished
	target.warp_player(body)


func _on_area_body_exited(_body: Node2D) -> void:
	can_teleport = true
