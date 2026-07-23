extends Node

signal money_updated(money: int)

var player_data: Dictionary = {}
var items: Dictionary = {}
var party: Array = [preload("res://Players/error.tres"), preload("res://Players/mac.tres")]
var flags: Dictionary = {}
var rooms: Dictionary = {}
var money: int = 9999:
	set(value):
		money = value
		money_updated.emit(money)

func _ready() -> void:
	Util.load_resources_to_dict("res://Items/", items)
	
	for v in party:
		v.init()
