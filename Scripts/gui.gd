class_name GUI extends CanvasLayer

@onready var top_menu: Menu = $Control/MarginContainer/HBoxContainer/TopMenu
@onready var player_windows: PlayerWindows = $Control/MarginContainer/PlayerWindows
@onready var inventory_menu: InventoryMenu = $Control/MarginContainer/HBoxContainer/InventoryMenu

func _ready() -> void:
	top_menu.hide()
	player_windows.hide()
	inventory_menu.hide()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.pressed and event.keycode == KEY_M:
		top_menu.visible = !top_menu.visible
		player_windows.visible = top_menu.visible
		get_tree().paused = top_menu.visible
		if top_menu.visible:
			top_menu.button_focus(0)

func _on_top_menu_button_pressed(button: BaseButton, _index: int) -> void:
	match button.text:
		"Items":
			inventory_menu.inventory = Data.party[player_windows.active_index].inventory
			inventory_menu.button_focus(0)
		"Quit":
			get_tree().quit()
		_:
			pass

func _on_top_menu_closed() -> void:
	player_windows.visible = false
	inventory_menu.visible = false
	get_tree().paused = false

func _on_inventory_menu_button_pressed(button: BaseButton, index: int) -> void:
	pass # Replace with function body.
