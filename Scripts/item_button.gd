class_name ItemButton extends Button

var item: Item = null:
	set(value):
		item = value
		
		if item:
			text = item.name
			show()
		else:
			hide()
