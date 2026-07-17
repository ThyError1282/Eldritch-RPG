class_name ScreenShake2D extends Camera2D

@export var decay = 0.8
@export var max_offset = Vector2(100, 75)
@export var max_roll = 0.1  
@export var noise: FastNoiseLite

var noise_y = 0
var trauma = 0.0  
var trauma_power = 2  

func _ready():
	Globals.screen_shake = self

func _process(delta: float) -> void:
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		_shake()
	
	elif offset.x != 0 or offset.y != 0 or rotation != 0:
		lerp(offset.x, 0, 0.1)
		lerp(offset.y, 0, 0.1)
		lerp(rotation, 0, 0.1)

func _shake() -> void:
	var amt = pow(trauma, trauma_power)
	noise_y += 1
	rotation = max_roll * amt * noise.get_noise_2d(noise.seed, noise_y)
	offset.x = max_offset.x * amt * noise.get_noise_2d(noise.seed * 2, noise_y)
	offset.y = max_offset.y * amt * noise.get_noise_2d(noise.seed * 3, noise_y)
	
	#if get_owner():
		#get_owner().get_node("Main").global_position = offset
	
func add_trauma(amount: float = 0.5) -> void:
	trauma = min(trauma + amount, 1.0)
