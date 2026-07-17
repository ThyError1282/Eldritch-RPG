class_name SpriteSheetAnimation extends Sprite2D

const Facing: Dictionary = Vectors.Facing

@export var no_right_frames: bool = true
@export var character_index: int = 0 :
	set(value):
		character_index = value #pull from actor.characters

#const FRAME_ADVANCE_TIME_IDLE: float = 0.25
#const FRAME_ADVANCE_TIME_MOVING: float = FRAME_ADVANCE_TIME_IDLE * 2

var frame_current: int = 0
var frame_max: int = 2
var frame_size: Vector2 = Vector2(0.0, 0.0)
#var frame_advance_time: float = FRAME_ADVANCE_TIME_IDLE
var seperation: Vector2 = Vector2(frame_size.x * 4, 0)

@onready var facing: Vectors.Facing = Vectors.Facing.DOWN

func set_texture_region_position() -> void:
	var buffer: Vector2 = Vector2.ZERO if frame_current == 0 else seperation
	texture.region.position = Vector2(facing, character_index) * frame_size + buffer

func set_facing(dir: Vector2) -> void:
	facing = Vectors.convert_vec2_to_facing_int(dir)
	
	if no_right_frames:
		if facing == Facing.RIGHT:
			facing = Facing.LEFT
			flip_h = true
		else:
			flip_h = false
	#hotfix to match current sheet.
	match facing:
		Facing.DOWN:
			facing = 0
		Facing.UP:
			facing = 1
	
	set_texture_region_position()

func frame_advance() -> void:
	frame_current = wrapi(frame_current + 1, 0, frame_max)

func _on_frame_advance_timeout() -> void:
	frame_advance()
	set_texture_region_position()
