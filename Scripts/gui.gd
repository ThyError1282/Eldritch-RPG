class_name GUI extends CanvasLayer

var current_player: BattleActor = null
var current_inventory: Inventory = null
var current_item: Item = null
var current_item_action: String = ""

@onready var party: Array = Data.party
@onready var top_menu: Menu = $Control/MarginContainer/HBoxContainer/TopMenu
@onready var items_modal: Menu = $Control/MarginContainer/HBoxContainer/ItemsModal
@onready var player_windows: PlayerWindows = $Control/MarginContainer/PlayerWindows
@onready var inventory_menu: InventoryMenu = $Control/MarginContainer/HBoxContainer/ItemsModal/InventoryMenu

func _unhandled_key_input(event: InputEvent) -> void:
	if not event.pressed:
		return
	
	if event.keycode == KEY_M:
		top_menu.visible = !top_menu.visible
		player_windows.close()
		player_windows.visible = top_menu.visible
		inventory_menu.visible = false
		items_modal.visible = false
		get_tree().paused = top_menu.visible
		if top_menu.visible:
			#top_menu._close_menus_in_front_of_self()
			top_menu.button_focus(0)
	else:
		return
	
	get_viewport().set_input_as_handled()

func _on_top_menu_button_pressed(button: BaseButton, _index: int) -> void:
	match button.text:
		"Items":
			inventory_menu.inventory = Data.party[player_windows.active_index].inventory
			items_modal.button_focus(0)
		"Quit":
			get_tree().quit()
		_:
			pass

func _on_items_modal_button_pressed(button: BaseButton, _index: int) -> void:
	current_item_action = button.text
	inventory_menu.button_focus(0)

func _on_inventory_menu_button_pressed(button: BaseButton, _index: int) -> void:
	current_item = button.item
	
	if current_item_action == "Discard":
		current_inventory.remove_item(current_item)
		current_item = null
		if current_inventory.is_empty():
			inventory_menu.close()
			items_modal.disable_all()
	else:
		player_windows.button_focus()

func _on_player_windows_button_pressed(button: BaseButton, index: int) -> void:
	if current_item:
		var player: BattleActor = button.data
		
		match current_item_action:
			"Use":
				pass
			"Give":
				if player == current_player:
					#TODO disable/grey out current window
					#TODO error sound?
					return
				
				var target_inventory: Inventory = player.inventory
				if target_inventory.add_item(current_item, 1):
					current_inventory.remove_item(current_item, 1)
				else:
					pass
					#TODO error sound
			_:
				return
		
		if current_inventory.is_empty():
			inventory_menu.close(true)
			items_modal.disable_all()

func _on_top_menu_closed() -> void:
	player_windows.visible = false
	items_modal.visible = false
	inventory_menu.visible = false
	get_tree().paused = false

func _on_player_windows_player_index_changed(index: int) -> void:
	await(get_tree().process_frame)
	current_player = party[index]
	current_inventory = current_player.inventory
	inventory_menu.inventory = current_inventory
	
	items_modal.disable_all(current_inventory.is_empty())
	
	if player_windows.menu_is_focused():
		player_windows.close()
