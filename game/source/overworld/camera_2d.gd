extends Camera2D


func _ready() -> void:
	print(owner.name)
	if owner.get("main_tilemap_layer"):
		var x: TileMapLayer = (owner.main_tilemap_layer as TileMapLayer)
		var map_rect: Rect2i = x.get_used_rect()
		var tile_size: Vector2i = x.tile_set.tile_size
		limit_top = map_rect.position.y * tile_size.y
		limit_left = map_rect.position.x * tile_size.x
		limit_bottom = limit_top + map_rect.size.y * tile_size.y
		limit_right = limit_left + map_rect.size.x * tile_size.x
		print(limit_top)
		print(limit_left)
		print(limit_bottom)
		print(limit_right)
