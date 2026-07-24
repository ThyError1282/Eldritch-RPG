class_name ItemButton extends Button

@onready var quantity: Label = $Quantity

var item: Item = null:
	set(value):
		item = value
		
		if item:
			text = item.name
			quantity.text = str(item.quantity)
			show()
		else:
			hide()
			text = " "
			quantity.text = " "
