class_name Room extends TileMapLayer

@onready var water: TileMapLayer = $Layers/Water

func collision(pos: Vector2) -> bool:
	var cell: Vector2 = local_to_map(pos)
	return water.get_cell_source_id(cell) != -1  
