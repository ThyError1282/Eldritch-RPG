extends Node

var party: Array = [preload("res://Players/error.tres"), preload("res://Players/mac.tres")]
var flags: Dictionary = {}
var rooms: Dictionary = {}

func _ready() -> void:
	#load_resources_to_dict("res://Items/", items)
	#Util.set_keys_to_names(items)
	party.append
	for v in party:
		v.init()
