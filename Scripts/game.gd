extends Node

const BATTLE: PackedScene = preload("res://Scenes/battle.tscn")

@onready var overworld: Room = $Overworld
@onready var current_room: Room = overworld
@onready var battle_layer: CanvasLayer = $BattleLayer

func _enter_tree() -> void:
	Globals.transition_handler = self

func _unhandled_key_input(event: InputEvent) -> void:
	if event.pressed:
		match event.keycode:
			KEY_B:
				goto_battle()

func goto_new_room(room: Room) -> void:
	# Init.
	get_tree().paused = true
	set_process_unhandled_key_input(false)
	await(ScreenEffects.fade(true))
	
	# Swap rooms.
	remove_child(current_room)
	get_tree().paused = false
	add_child(room)
	current_room = room
	await(ScreenEffects.fade(false))
	
	set_process_unhandled_key_input(true)

func goto_battle(enemies_weighted: Array = []) -> void:
	get_tree().paused = true
	set_process_unhandled_key_input(false)
	await(ScreenEffects.fade(true, 0.5)) # TODO replace with proper effects
	remove_child(current_room)
	#await(get_tree().process_frame)
	get_tree().paused = false
	
	var battle: Node = BATTLE.instantiate()
	battle.enemies_weighted = enemies_weighted
	battle.battle_won.connect(_on_battle_won)
	battle.battle_lost.connect(_on_battle_lost)
	battle_layer.add_child(battle)
	
	ScreenEffects.fade(false, 0.5)
	await(battle.tree_exiting)
	set_process_unhandled_key_input(true)
	add_child(current_room)

func _on_transition_area_triggered(room_path: String) -> void:
	goto_new_room(load(room_path).instantiate())

func _on_room_enemy_encountered(enemies_weighted: Array) -> void:
	goto_battle(enemies_weighted)

func _on_battle_won() -> void:
	pass

func _on_battle_lost() -> void:
	get_tree().quit()
