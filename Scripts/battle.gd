extends Control

enum States {
	START,
	RUNNING,
	VICTORY,
	GAMEOVER
}

signal battle_won
signal battle_lost

const Actions: Dictionary = EventQueue.Actions

var party: Array = Data.party
var state: States = States.START
var current_action: EventQueue.Actions = -1
var current_player_index: int = -1
var current_item: Item = null
var enemies_weighted: Array = []

@onready var event_queue: EventQueue = $EventQueue
@onready var options: Menu = $MarginContainer/Options
@onready var enemies: Menu = $Enemies
@onready var player_windows: PlayerWindows = $MarginContainer/PlayerWindows
@onready var textbox: Textbox = $MarginContainer/Textbox
@onready var inventory_menu: InventoryMenu = $MarginContainer/InventoryMenu

func _roll_enemy_actions() -> void:
	for enemy: Enemy in enemies.get_buttons():
		var actor: BattleActor = enemy.data
		var target: BattleActor = party.pick_random()
		event_queue.add(Actions.FIGHT, actor, target, null)

func _ready() -> void:
	var spawn_chance: float = 1.0
	var enemy_data: BattleActor = Data.enemies.elve
	for enemy: Enemy in enemies.get_buttons():
		if randf() > spawn_chance:
			enemy.hide()
			continue
		
		spawn_chance *= 0.75
		if enemies_weighted:
			var enemy_key: String = Arrays.choose_weighted(enemies_weighted)
			enemy_data = Data.enemies[enemy_key]
		
		enemy.data = enemy_data
		enemy.enemy_dead.connect(_on_enemy_dead)
	
	#for enemy: Enemy in enemies.get_buttons():
		#enemy.enemy_dead.connect(_on_enemy_dead)
	
	for player: BattleActor in party:
		player.hp_changed.connect(_on_player_hp_changed)
	
	goto_next_player()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if enemies.close() or player_windows.close() or inventory_menu.close(true):
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
	inventory_menu.hide()
	
	if current_player_index >= party.size():
		_roll_enemy_actions()
		# TODO sort by speed rolls but added randomization
		event_queue.shuffle()
		options.hide()
		enemies.release()
		player_windows.activate(-1)
		await(event_queue.run())
		current_player_index = 0
	
	match state:
		States.START:
			current_action = -1
			current_item = null
			player_windows.activate(current_player_index)
			options.button_focus()
			return
		States.VICTORY:
			textbox.handle_input = true
			textbox.start("", ["You Win!"])
			await(get_tree().create_timer(2.0).timeout)
			textbox.stop()
			battle_won.emit()
			queue_free()
		States.GAMEOVER:
			textbox.handle_input = true
			textbox.start("", ["You Lost!"])
			await(get_tree().create_timer(2.0).timeout)
			textbox.stop()
			battle_lost.emit()
			queue_free()
		States.RUNNING:
			textbox.handle_input = true
			textbox.start("", ["You Ran Away!"])
			await(get_tree().create_timer(2.0).timeout)
			textbox.stop()
			battle_won.emit()
			queue_free()

func _on_options_button_pressed(button: BaseButton, _index: int) -> void:
	
	match button.text:
		"Fight":
			current_action = Actions.FIGHT
			enemies.button_focus()
		"Item":
			current_action = Actions.ITEM
			inventory_menu.inventory = party[current_player_index].inventory
			inventory_menu.button_focus(0)
		"Flee":
			state = States.RUNNING
			goto_next_player()
		_:
			pass

func _on_enemies_button_pressed(button: BaseButton, _index: int) -> void:
	event_queue.add(current_action, party[current_player_index], button.data, current_item)
	goto_next_player()

func _on_inventory_menu_button_pressed(button: BaseButton, _index: int) -> void:
	if button.item:
		current_item = button.item
		player_windows.button_focus(0)

func _on_player_windows_button_pressed(button: BaseButton, _index: int) -> void:
	event_queue.add(current_action, party[current_player_index], button.data, current_item)
	goto_next_player()

func _on_enemy_dead(_enemy: Enemy) -> void:
	for enemy: Enemy in enemies.get_buttons():
		if enemy.data.hp > 0:
			return
	
	state = States.VICTORY

func _on_player_hp_changed(_hp: int, _hp_max: int, _value_change: int) -> void:
	for player: BattleActor in party:
		if player.hp > 0:
			return
	
	state = States.GAMEOVER
