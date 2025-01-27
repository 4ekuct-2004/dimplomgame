extends Item
class_name ItemBananas

func _init() -> void:
	icon = preload("res://assets/items/ready/item_bananas.png")
	item_name = "Бананы"
	item_desc = "Пока ты это читал, они уже почернели."
	rank = 5
