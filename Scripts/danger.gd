class_name Danger extends Node

signal target_reached(enemies_weighted: Array)

const TARGET_BASE: int = 2

@export var enabled: bool = true
@export var range_min: int = 8
@export var range_max: int = 24
@export var enemies_weighted: Array = ["", 1, "", 1,"", 1, "", 1,"", 1, "", 1,"", 1, "", 1]

var target: int = 0

func _ready() -> void:
	target_reached.connect(get_parent()._danger_target_reached)
	reroll_target()
	
	if enemies_weighted.front() == "":
		enemies_weighted.clear()
	else:
		for i in range(enemies_weighted.size()):
			var value = enemies_weighted[i]
			if value is String and value == "":
				enemies_weighted.resize(i)
				break
	
	await(get_tree().process_frame)
	Globals.player.moved.connect(_on_player_moved)

func _unhandled_key_input(event: InputEvent) -> void:
	if event.pressed and event.keycode == KEY_1:
		enabled = !enabled
		get_viewport().set_input_as_handled()

func reroll_target() -> void:
	target = randi_range(range_min, range_max) + TARGET_BASE

func _on_player_moved(_position: Vector2) -> void:
	if !enabled:
		return
	
	target -= 1
	if target <= 0:
		target_reached.emit(enemies_weighted)
		reroll_target()
