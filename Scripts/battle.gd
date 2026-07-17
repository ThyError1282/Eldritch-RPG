extends Control

const Actions: Dictionary = EventQueue.Actions

var party: Array = Data.party
var current_action: EventQueue.Actions = -1
var current_player_index: int = -1
var current_item: Item = null

@onready var event_queue: EventQueue = $EventQueue
@onready var options: Menu = $MarginContainer/Options
@onready var enemies: Menu = $Enemies
@onready var player_windows: PlayerWindows = $MarginContainer/PlayerWindows
@onready var textbox: PanelContainer = $MarginContainer/Textbox
@onready var inventory: InventoryMenu = $MarginContainer/Inventory

func _ready() -> void:
	goto_next_player()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if enemies.close() or player_windows.close() or inventory.close(true):
			options.button_focus()
		elif current_player_index > 0 and options.menu_is_focused():
			event_queue.pop_back()
			goto_next_player(-1)
		else:
			return
		
		get_viewport().set_input_as_handled()

func goto_next_player(dir: int = 1) -> void:
	dir = clampi(dir, -1, 1)
	current_player_index += dir
	current_player_index = clampi(current_player_index, 0, party.size())
	inventory.hide()
	
	if current_player_index >= party.size():
		for enemy: Enemy in enemies.get_buttons():
			var actor: BattleActor = enemy.data
			var target: BattleActor = party.pick_random() # TODO actual AI based targetting
			event_queue.add(Actions.FIGHT, actor, target, null) # TODO picking actions
		
		# TODO sort by speed rolls but added randomization
		event_queue.shuffle()
		options.hide()
		enemies.release()
		player_windows.activate(-1)
		await(event_queue.run())
		current_player_index = 0
	
	current_action = -1
	current_item = null
	player_windows.activate(current_player_index)
	options.button_focus()

func _on_options_button_pressed(button: BaseButton, _index: int) -> void:
	
	match button.text:
		"Fight":
			current_action = Actions.FIGHT
			enemies.button_focus()
		"Item":
			current_action = Actions.ITEM
			inventory.inventory = party[current_player_index].inventory
			inventory.button_focus(0)
		_:
			pass

func _on_enemies_button_pressed(button: BaseButton, _index: int) -> void:
	event_queue.add(current_action, party[current_player_index], button.data, current_item)
	goto_next_player()

func _on_inventory_button_pressed(button: BaseButton, _index: int) -> void:
	if button.item:
		current_item = button.item
		player_windows.button_focus(0)

func _on_player_windows_button_pressed(button: BaseButton, _index: int) -> void:
	event_queue.add(current_action, party[current_player_index], button.data, current_item)
	goto_next_player()
