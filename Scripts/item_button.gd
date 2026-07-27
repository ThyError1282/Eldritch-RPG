class_name ItemButton extends Button

const ITEM_ICONS: AtlasTexture = preload("res://Art/item_icons.tres")

var item_icons: AtlasTexture = ITEM_ICONS.duplicate()

@onready var quantity: Label = $Quantity

var item: Item = null:
	set(value):
		item = value
		
		if item:
			text = item.name
			quantity.text = str(item.quantity)
			item_icons.region.position.x = item.type * item_icons.region.size.x
			icon = item_icons
			show()
		else:
			hide()
			text = " "
			quantity.text = " "
			icon = null

var show_quantity: bool = true:
	set(value):
		show_quantity = value
		quantity.visible = show_quantity

func _ready() -> void:
	icon = null
