class_name Clock extends Label

@warning_ignore("unused_signal")
signal date_changed(days_total: int)
signal time_tick(time: float, day: int, hour: int, minute: int)

const MINUTES_PER_DAY: int = 1440
const MINUTES_PER_HOUR: int = 60
const INGAME_TO_REAL_MINUTE_DURATION: float = (2 * PI) / MINUTES_PER_DAY

@export var INGAME_SPEED: float = 1.0
@export var INITIAL_HOUR: int = 6
@export var INITIAL_MINUTE: int = 0
@export var draw_seconds: bool = false

var time: float = 0.0
var past_minute: float = -1.0
var days_total: int = 0

func _ready() -> void:
	Globals.clock = self
	reset_time()

func _process(delta: float) -> void:
	time += delta * INGAME_TO_REAL_MINUTE_DURATION * INGAME_SPEED
	_recalculate_time()

func reset_time() -> void:
	time = INGAME_TO_REAL_MINUTE_DURATION * (INITIAL_HOUR * MINUTES_PER_HOUR + INITIAL_MINUTE)

func advance_day() -> void:
	days_total += 1
	reset_time()

func _recalculate_time() -> void:
	var total_minutes: int = int(time / INGAME_TO_REAL_MINUTE_DURATION)
	var day: int = int(total_minutes / MINUTES_PER_DAY)
	var current_day_minutes: int = total_minutes % MINUTES_PER_DAY
	var hour: int = int(current_day_minutes / MINUTES_PER_HOUR)
	var minute: int = int(current_day_minutes % MINUTES_PER_HOUR)
	
	var hours_prefix: String = ""
	var minutes_prefix: String = ""
	var suffix: String = "AM"
	
	if hour < 10:
		hours_prefix = "AM"
	elif hour >= 12:
		hours_prefix = "PM"
	
	if day > days_total:
		date_changed.emit(days_total)
	
	if minute != past_minute:
		past_minute = minute
		time_tick.emit(time, days_total, hour, minute)
		
	text = str(hour) + ":" + str(minute) + " " + suffix
