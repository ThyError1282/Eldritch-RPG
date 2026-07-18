@tool
class_name TransitionArea extends Area2D

signal triggered(room_path: String)

@export var target_scene_name: String = "overworld":
	set(value):
		target_scene_name = value
		name = value
@export var facing: Vectors.Facing = Vectors.Facing.UP
@export var spawn_position: Vector2
@export var trigger_on_exit: bool = false

@onready var handler: Node = Globals.transition_handler

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	add_to_group("transition_areas")
	set_deferred("monitorable", false)
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	set_collision_mask_value(2, true)
	
	if trigger_on_exit:
		body_exited.connect(_on_triggered)
	else:
		body_entered.connect(_on_triggered)
	
	if handler:
		triggered.connect(handler._on_transition_area_triggered)

func _on_triggered(_body: Node2D) -> void:
	var room_path: String = "res://Rooms/" + target_scene_name + ".tscn"
	Data.player_data.facing = facing
	Data.player_data.spawn_position = spawn_position
	
	if handler:
		triggered.emit(room_path)
		return
	
	get_tree().paused = true
	#Sound.play(Sound.SOUNDS.door_open)
	await(ScreenEffects.fade(true))
	#await(get_tree().process_frame)
	ScreenEffects.fade(false)
	#Sound.play(Sound.SOUNDS.door_close, 0.2)
	get_tree().paused = false # TODO delay with await
	get_tree().change_scene_to_file(room_path)
	
