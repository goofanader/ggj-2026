extends Node
class_name ItemManager

var items: Dictionary = {} # item id, ItemInfo

func add_item(item: ItemInfo) -> void:
	if item == null:
		return
	items[item.id] = item

func remove_item(item: ItemInfo) -> void:
	if item == null:
		return
	items.erase(item.id)

func use_item(item: ItemInfo) -> void:
	if not items.has(item.id):
		return
