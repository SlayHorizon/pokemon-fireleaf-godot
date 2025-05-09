extends Camera2D


func _ready() -> void:
	pass


func set_camera_limits_from_tilemap(tilemap: TileMap) -> void:
	var map_rect: Rect2i = tilemap.get_used_rect()
	var tile_size: Vector2i = tilemap.tile_set.tile_size
	limit_top = map_rect.position.y * tile_size.y
	limit_left = map_rect.position.x * tile_size.x
	limit_bottom = limit_top + map_rect.size.y * tile_size.y
	limit_right = limit_left + map_rect.size.x * tile_size.x
