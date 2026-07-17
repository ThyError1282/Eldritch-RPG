class_name InventoryMenu extends Menu

var inventory: Inventory = null:
	set(value):
		if inventory == value:
			return
		
		#if inventory:
			#inventory.updated.disconnect(_on_inventory_updated)
		inventory = value
		
		for button: BaseButton in get_buttons():
			button.item = (inventory.get_item_by_position(button.get_index()))

func _ready() -> void:
	super()
	hide()

func _on_inventory_updated() -> void:
	pass
