class_name BattleActor extends Resource

signal hp_changed(hp, hp_max, amount_change)

@export var sprite: Texture = null
@export var name: String = ""
@export var hp_max: int = 1
@export var mp_max: int = 0
@export var attack: int = 2
@export var defense: int = 1
@export var items: Array[Item] = []
@export var equipment: Array[Item] = [null, null, null, null, null, null]
@export var xp: int = 1
@export var gold: int = 1

var hp: int = hp_max
var mp: int = mp_max
var inventory: Inventory = null
var key: String = ""

func init() -> void:
	hp = hp_max
	mp = mp_max
	
	if items:
		inventory = Inventory.new()
		for item: Item in items:
			inventory.add_item(item)
	
	for i in range(equipment.size()):
		equip(equipment[i])

func copy() -> BattleActor:
	var dupe: BattleActor = duplicate()
	dupe.init()
	dupe.sprite = sprite
	dupe.name = name
	dupe.key = key
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

func equip(item: Item) -> void:
	if not item:
		return
	
	var item_copy: Item = item.duplicate_custom()
	inventory.remove_item(item)
	
	var slot: Item.Types = item.slot
	var previous_item: Item = equipment[slot]
	equipment[slot] = item_copy
	inventory.add_item(previous_item)

func unequip(slot: int) -> bool:
	var item: Item = equipment[slot]
	if inventory.add_item(item):
		equipment[slot] = null
		return true
	return false

func unequip_all() -> void:
	for i in range(equipment.size()):
		unequip(i)

func get_total_attack() -> int:
	var n: int = attack
	for item: Item in equipment:
		n += item.attack if item else 0
	return n

func get_total_defense() -> int:
	var n: int = defense
	for item: Item in equipment:
		n += item.defense if item else 0
	return n
