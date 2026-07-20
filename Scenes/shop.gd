class_name Shop extends CanvasLayer

@onready var main: VBoxContainer = $Control/MarginContainer/VBoxContainer/Main
@onready var inventory: InventoryMenu = $Control/MarginContainer/VBoxContainer/Main/HBoxContainer/Inventory
@onready var top_menu: Menu = $Control/TopMenu

func _ready() -> void:
	main.hide()
	get_tree().paused = true

func _exit() -> void:
	get_tree().paused = false
	queue_free()

func _on_top_menu_button_pressed(button: BaseButton, index: int) -> void:
	top_menu.hide()
	
	match button.text:
		"Buy":
			main.show()
			inventory.button_focus(0)
		"Sell":
			main.show()
			inventory.button_focus(0)
		"Exit":
			_exit()


func _on_inventory_closed() -> void:
	main.hide()
	top_menu.button_focus()


func _on_top_menu_closed() -> void:
	_exit()
