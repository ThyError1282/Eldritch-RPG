class_name InventoryMenu extends Menu

signal updated(inventory: Inventory)

var inventory: Inventory = null:
	set(value):
		if inventory == value:
			return
		
		if inventory:
			inventory.updated.disconnect(_on_inventory_menu_updated)
		
		inventory = value
		inventory.updated.connect(_on_inventory_menu_updated)
		_update_buttons()

func _ready() -> void:
	super()
	hide()

func _update_buttons() -> void:
	for button: BaseButton in get_buttons():
		button.item = (inventory.get_item_by_position(button.get_index()))
	updated.emit(inventory)

func _on_inventory_menu_updated() -> void:
	_update_buttons()
