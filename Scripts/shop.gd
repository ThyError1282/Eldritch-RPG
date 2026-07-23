class_name Shop extends CanvasLayer

var current_item: Item = null

@onready var main: VBoxContainer = $Control/MarginContainer/VBoxContainer/Main
@onready var inventory_menu: InventoryMenu = $Control/MarginContainer/VBoxContainer/Main/HBoxContainer/Inventory
@onready var top_menu: Menu = $Control/TopMenu
@onready var costs: Array = $Control/MarginContainer/VBoxContainer/Main/HBoxContainer/Inventory/ScrollContainer/HBoxContainer/Costs.get_children()
@onready var shop_order_menu: Menu = $Control/MarginContainer/VBoxContainer/Main/HBoxContainer/RightSide/ShopOrderMenu
@onready var description: Label = $Control/MarginContainer/VBoxContainer/Main/Description/Description
@onready var dialogue: Label = $Control/MarginContainer/VBoxContainer/TopBar/Dialogue/Dialogue
@onready var players: Menu = $Control/MarginContainer/VBoxContainer/Main/Players

func _ready() -> void:
	main.hide()
	shop_order_menu.show()
	get_tree().paused = true

func _exit() -> void:
	get_tree().paused = false
	queue_free()

func set_inventory(inventory: Inventory) -> void:
	inventory_menu.inventory = inventory

func _on_top_menu_button_pressed(button: BaseButton, index: int) -> void:
	top_menu.hide()
	
	match button.text:
		"Buy":
			dialogue.text = "See anything ya like?"
			main.show()
			inventory_menu.button_focus(0)
		"Sell":
			dialogue.text = "What ya interested in pawning?"
			main.show()
			inventory_menu.button_focus(0)
		"Exit":
			_exit()

func _on_inventory_updated(inventory: Inventory) -> void:
	for i in range(costs.size()):
		var item: Item = inventory.get_item_by_position(i)
		if item:
			costs[i].text = str(item.value)
		else:
			costs[i].text = " "

func _on_inventory_button_focused(button: BaseButton, _index: int) -> void:
	if button.item:
		description.text = button.item.description
	else:
		description.text = ""

func _on_inventory_button_pressed(button: BaseButton, _index: int) -> void:
	shop_order_menu.start(button.item)

func _on_shop_order_menu_item_and_quantity_selected(item: Item, quantity: int) -> void:
	current_item = item.duplicate_custom()
	current_item.quantity = quantity
	players.button_focus()

func _on_players_button_pressed(_button: BaseButton, index: int) -> void:
	var player: BattleActor = Data.party[index]
	player.inventory.add_item(current_item)
	Data.money -= current_item.get_total_value()
	shop_order_menu.clear()
	inventory_menu.button_focus()

func _on_inventory_closed() -> void:
	dialogue.text = "Welcome!"
	main.hide()
	top_menu.button_focus()

func _on_top_menu_closed() -> void:
	_exit()

func _on_shop_order_menu_closed() -> void:
	inventory_menu.button_focus()
