class_name Item extends Resource

signal updated(quantity: int)

const TEXTURE: AtlasTexture = null

@export var name: String = ""
@export var texture: AtlasTexture = null
@export var quantity: int = 1:
	set(n):
		quantity = n
		updated.emit(quantity)

@export var quantity_max: int = 1
@export var value: int = 0
@export_multiline var description: String = ""

var key: String = ""

func duplicate_custom() -> Item:
	var dupe: Item = self.duplicate()
	dupe.name = name
	dupe.quantity = quantity
	return dupe

func can_stack(quantity: int) -> bool:
	return self.quantity + quantity < self.quantity_max

func get_total_value() -> int:
	return value * quantity
