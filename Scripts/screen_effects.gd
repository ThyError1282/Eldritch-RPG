extends CanvasLayer

var tween: Tween = null

@onready var fill: ColorRect = $Fill

func fade(out: bool, duration: float = 0.5, color: Color = Color.BLACK) -> void:
	if tween:
		tween.kill()
	
	var target: float
	var ease_type: int
	if out:
		fill.color.a = 0.0
		target = 1.0
		ease_type = Tween.EASE_IN
	else:
		fill.color.a = 1.0
		target = 0.0
		ease_type = Tween.EASE_OUT
	
	tween = create_tween()
	tween.tween_property(fill, "color:a", target, duration).set_trans(Tween.TRANS_SINE).set_ease(ease_type)
	await(tween.finished)
