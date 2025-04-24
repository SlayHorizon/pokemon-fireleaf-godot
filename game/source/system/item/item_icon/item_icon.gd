@tool
class_name ItemIcon
extends Sprite2D


@export var item: Item:
	set = _set_item


func _set_item(new_item: Item) -> void:
	item = new_item
	if not new_item:
		return
	texture = item.icon_spritesheet
	hframes = texture.get_width() / 24
	vframes = texture.get_height() / 24
	if item.custom_icon_index == -1:
		frame = item.icon_index.get(item.item_name, 0)
	else:
		frame = item.custom_icon_index
	print(frame)
