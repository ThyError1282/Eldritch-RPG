class_name BattleActor extends Resource

signal hp_changed(hp, hp_max, amount_change)

@export var sprite: Texture = null
@export var name: String = ""
@export var hp_max: int = 1
@export var mp_max: int = 0
@export var attack: int = 2
@export var defense: int = 1
@export var items: Array[Item] = []
@export var xp: int = 1
@export var gold: int = 1

var hp: int = hp_max
var mp: int = mp_max
var inventory: Inventory = null

func init() -> void:
	hp = hp_max
	mp = mp_max
	
	if items:
		inventory = Inventory.new()
		for item: Item in items:
			inventory.add_item(item)

func copy() -> BattleActor:
	var dupe: BattleActor = duplicate()
	dupe.init()
	return dupe

func is_defeated() -> bool:
	return hp <= 0

func can_act() -> bool:
	return not is_defeated()

func damage_roll(target: BattleActor) -> int:
	return -attack + target.defense

func healhurt(value: int) -> int:
	var previous_hp: int = hp
	hp += value
	
	var value_change: int = hp - previous_hp
	hp = clampi(hp, 0, hp_max)
	hp_changed.emit(hp, hp_max, value_change)
	return value_change
