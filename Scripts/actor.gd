class_name Actor extends CharacterBody2D

var facing: Vector2 = Vector2.DOWN

@onready var current_room: Room = get_owner()
@onready var target_position: Vector2 = position
@onready var sprite: SpriteSheetAnimation = $SpriteSheetAnimation

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	idle()

func idle() -> void:
	var facing_string: String = Vectors.convert_vec2_to_facing_string(facing)
	
	if facing_string == "RIGHT":
		facing_string = "LEFT"
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	
	sprite.set_facing(facing)
