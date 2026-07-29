class_name Room extends TileMapLayer

signal enemy_encountered(enemies_weighted: Array)

@export var pause_clock: bool = false

@onready var water: TileMapLayer = $Layers/Water
@onready var walls: TileMapLayer = $Layers/Walls

func _ready() -> void:
	enemy_encountered.connect(get_parent()._on_room_enemy_encountered)
	process_mode = PROCESS_MODE_PAUSABLE
	await(get_tree().process_frame)
	await(get_tree().process_frame)
	Globals.clock.pause(pause_clock)

func collision(pos: Vector2) -> bool:
	var cell: Vector2 = local_to_map(pos)
	return water.get_cell_source_id(cell) != -1 or walls.get_cell_source_id(cell) != -1

func _danger_target_reached(enemies_weighted: Array) -> void:
	enemy_encountered.emit(enemies_weighted)
