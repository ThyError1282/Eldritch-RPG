class_name DayNightCycle extends CanvasModulate

@export var gradient: GradientTexture1D = preload("res://DayNightCycle/day_night_cycle.tres")

func _ready() -> void:
	if not Globals.clock:
		var clock: Clock = Clock.new()
		clock.visible = false
		clock.INGAME_SPEED = 20.0
		add_child(clock)
		Globals.clock = clock
		
	Globals.clock.time_tick.connect(_on_clock_time_tick)

func _on_clock_time_tick(time: float, _day: int, _hour: int, _minutes: int) -> void:
	var value: float = (sin(time - PI/2) + 1.0) / 2.0
	color = gradient.gradient.sample(value)
