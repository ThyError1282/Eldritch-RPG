extends Menu

signal item_and_quantity_selected(item: Item, quantity: int)

var item: Item = null
var current_quantity: int = 1

@onready var item_name: Label = $Main/ItemName
@onready var quantity: Label = $Main/Buttons/Quantity/Quantity
@onready var cost: Label = $Main/Cost/Cost
@onready var arrow_blinking_left: ArrowBlinking = $Main/Buttons/Quantity/ArrowBlinkingLeft
@onready var arrow_blinking_right: ArrowBlinking = $Main/Buttons/Quantity/ArrowBlinkingRight
@onready var main: VBoxContainer = $Main

func _ready() -> void:
	super()
	clear()

func _unhandled_key_input(event: InputEvent) -> void:
	if not event.pressed:
		return
	
	match event.keycode:
		KEY_A:
			_change_quantity(-1)
		KEY_D:
			_change_quantity(1)
		KEY_LEFT:
			_change_quantity(-1)
		KEY_RIGHT:
			_change_quantity(1)
		_:
			return
	
	get_viewport().set_input_as_handled()

func _change_quantity(dir: int) -> void:
	var quantity_max: int = item.quantity_max # TODO if selling limit to item.quantity instead
	current_quantity = clampi(current_quantity + dir, 1, quantity_max)
	quantity.text = str(current_quantity)
	cost.text = str(item.value * current_quantity)
	# TODO make cost red or etc when no funds?
	arrow_blinking_left.enable(current_quantity > 1)
	arrow_blinking_right.enable(current_quantity < quantity_max)
	
	var show_arrows: bool = quantity_max > 1
	arrow_blinking_left.visible = show_arrows
	arrow_blinking_right.visible = show_arrows

func start(item: Item) -> void:
	self.item = item
	item_name.text = item.name
	_change_quantity(-9999)
	main.show()
	await get_tree().process_frame
	button_focus(0)
	set_process_unhandled_key_input(true)

func clear() -> void:
	item = null
	main.hide()
	set_process_unhandled_key_input(false)

func _on_button_pressed(_button: BaseButton, _index: int) -> void:
	if Data.money > int(cost.text):
		item_and_quantity_selected.emit(item, current_quantity)
	else:
		pass
		# TODO error sound

func _on_closed() -> void:
	clear()
