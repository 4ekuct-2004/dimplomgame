extends Node
class_name Inventory

var items: Array[Item]
var inv_size: int

func _init(inv_size: int) -> void:
	self.inv_size = inv_size

func add_item(item: Item):
	if items.size() >= inv_size and inv_size != -1: return
	items.append(item)

func remove_item(item: Item):
	if items.has(item): items.erase(item)
	
	
