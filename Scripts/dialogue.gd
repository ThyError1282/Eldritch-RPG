class_name Dialogue extends Node

const DATA: Array = [
	#B
	[
		"... Welcome, you must p3w bc we r EA!",
	],
]

static func get_from_id(id: int) -> Array:
	return DATA[id]
