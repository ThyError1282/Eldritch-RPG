class_name ArrowBlinking extends AnimatedSprite2D

func enable(on: bool) -> void:
	if on:
		modulate = Color.WHITE
	else:
		modulate = Color.DIM_GRAY
