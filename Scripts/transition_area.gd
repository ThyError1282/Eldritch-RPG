@tool
class_name TransitionArea extends Area2D

@export var target_scene_name: String = "overworld":
	set(value):
		target_scene_name = value
		name = value
@export var facing: Vectors.Facing = Vectors.Facing.UP
@export var spawn_position: Vector2

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	add_to_group("transition_areas")
	set_deferred("monitorable", false)
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	set_collision_mask_value(2, true)
	body_entered.connect(_on_body_entered)

func _on_body_entered(_body: Node2D) -> void:
	get_tree().paused = true
	#Sound.play(Sound.SOUNDS.door_open)
	await(ScreenEffects.fade(true))
	#await(get_tree().process_frame)
	Data.player_data.facing = facing
	Data.player_data.spawn_position = spawn_position
	ScreenEffects.fade(false)
	#Sound.play(Sound.SOUNDS.door_close, 0.2)
	get_tree().paused = false # TODO delay with await
	get_tree().change_scene_to_file("res://Rooms/" + target_scene_name + ".tscn")
	
