class_name Player extends Actor

signal moved(pos: Vector2)

const TILE_SIZE: Vector2 = Globals.CELL_SIZE

@export var speed: int = 60
@export var on_grid: bool = true
@export var diagonal_allowed: bool = false

#var target_position: Vector2 = Vector2.ZERO

@onready var data: Dictionary = Data.player_data
@onready var interact_range: Area2D = $InteractRange


func _ready() -> void:
	super()
	Globals.player = self
	#position = data.get("spawn_position", position)
	moved.emit(position)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		var interactables: Array = interact_range.get_overlapping_bodies()
		if interactables:
			for node in interactables:
				node.interact()
				return
	
	if on_grid:
		position = position.move_toward(target_position, speed * delta)
		
		if not position.is_equal_approx(target_position):
			return
	
	var movement: Vector2 = Vectors.get_four_direction_vector(diagonal_allowed)
	if movement.is_zero_approx():
		#sprite.idle()
		return
	
	facing = Vectors.clamp_to_four_dir(movement)
	sprite.set_facing(facing)
	#queue_redraw()
	
	if on_grid:
		target_position = position + TILE_SIZE * movement
		
		if move_and_collide(movement * TILE_SIZE, true) or current_room.collision(target_position):
			target_position = position
			return
	else:
		velocity = movement.normalized() * speed
		move_and_slide()
	
	#moved.emit(position)
