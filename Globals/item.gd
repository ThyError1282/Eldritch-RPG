class_name Item extends Resource

signal updated(quantity: int)

enum Types {
	NOT_SET,
	SHIELD,
	HELM,
	CHEST,
	LEGS,
	BOOTS,
	ACCESSORY,
	CONSUMABLE,
	KEY,
	BOOK,
	SWORD,
	DAGGER,
	STAFF,
}


const TEXTURE: AtlasTexture = null

@export var name: String = ""
@export var type: Types = Types.NOT_SET
@export var texture: AtlasTexture = null
@export var quantity: int = 1:
	set(n):
		quantity = n
		updated.emit(quantity)

@export var quantity_max: int = 1
@export var attack: int = 0
@export var defense: int = 0
@export var magic: int = 0
@export var speed: int = 0
@export var value: int = 0
@export_multiline var description: String = ""

var key: String = ""

func duplicate_custom() -> Item:
	var dupe: Item = self.duplicate()
	dupe.name = name
	dupe.quantity = quantity
	dupe.description = description
	dupe.value = value
	dupe.attack = attack
	dupe.defense = defense
	dupe.magic = magic
	dupe.speed = speed
	dupe.key = key
	return dupe

func can_stack(quantity: int) -> bool:
	return self.quantity + quantity < self.quantity_max

func get_total_value() -> int:
	return value * quantity
