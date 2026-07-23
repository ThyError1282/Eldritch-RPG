class_name Door extends Area2D

@onready var sprite: Sprite2D = $Sprite
@onready var open_sound: AudioStreamPlayer2D = $OpenSound
@onready var close_sound: AudioStreamPlayer2D = $CloseSound

func _is_open() -> bool:
	return not visible

func _open(open: bool) -> void:
	if open == _is_open():
		return
	
	visible = !visible
	if open:
		open_sound.play()
	else:
		close_sound.play()


func _on_body_entered(_body: Node2D) -> void:
	_open(true)


func _on_body_exited(_body: Node2D) -> void:
	await(get_tree().create_timer(0.1).timeout)
	_open(false)
