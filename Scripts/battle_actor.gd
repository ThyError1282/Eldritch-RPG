class_name BattleActor extends Resource

signal hp_changed(hp, hp_max, amount_change)

@export var sprite: Texture = null
@export var name: String = ""
@export var hp_max: int = 1
@export var mp_max: int = 0

var hp: int = hp_max
var mp: int = mp_max

func init() -> void:
	hp = hp_max
	mp = mp_max

func copy() -> BattleActor:
	var dupe: BattleActor = duplicate()
	dupe.init()
	return dupe

func healhurt(value: int) -> int:
	var previous_hp: int = hp
	hp += value
	
	var value_change: int = previous_hp - hp
	hp = clampi(hp, 0, hp_max)
	hp_changed.emit(hp, hp_max, value_change)
	return value_change
