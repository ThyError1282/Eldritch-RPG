extends Node

var player_data: Dictionary = {}
var items: Dictionary = {}
var party: Array = [preload("res://Players/error.tres")] #, preload("res://Players/mac.tres")]
var flags: Dictionary = {}
var rooms: Dictionary = {}


func _ready() -> void:
	Util.load_resources_to_dict("res://Items/", items)
	Util.set_keys_to_names(items)
	
	for v in party:
		v.init()
