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

func goto_battle() -> void:
	get_tree().paused = true
	set_process_unhandled_key_input(false)
	await(ScreenEffects.fade(true, 0.5)) # TODO replace with proper effects
	remove_child(current_room)
	#await(get_tree().process_frame)
	get_tree().paused = false
	
	var battle: Node = BATTLE.instantiate()
	battle_layer.add_child(battle)
	
	ScreenEffects.fade(false, 0.5)
	await(battle.tree_exiting)
	set_process_unhandled_key_input(true)
	add_child(current_room)

func _on_transition_area_triggered(room_path: String) -> void:
	goto_new_room(load(room_path).instantiate())
