class_name NPC extends Actor

const SHOP: PackedScene = preload("res://Scenes/shop.tscn")

@export var is_shopkeeper: bool = false
@export var character_index: int = 0:
	set(value):
		character_index = value
		
		if sprite:
			sprite.character_index = value
@export var dialogue_id: int = 0

func _ready() -> void:
	super()
	sprite.character_index = character_index

func interact() -> void:
	#print(name + " says hi.")
	
	facing = Globals.player.facing * -1
	idle()
	
	if is_shopkeeper:
		var shop: Shop = SHOP.instantiate()
		add_child(shop)
	else:
		var text: Array = Dialogue.get_from_id(dialogue_id)
		if Globals.textbox:
			Globals.textbox.start(name, text)
		else:
			print_debug(text)
