class_name PlayerWindows extends Menu

signal player_index_changed(index: int)

@export var handle_input: bool = false
@export var activate_on_start: bool = false

var active_index: int = -1

@onready var party: Array = Data.party

func _ready() -> void:
	for i in range(get_child_count()):
		if i < party.size():
			get_child(i).data = party[i]
		else:
			get_child(i).data = null
	super()
	
	set_process_unhandled_key_input(handle_input)
	if activate_on_start:
		activate(0)

func _unhandled_key_input(event: InputEvent) -> void:
	if not event.pressed:
		return
	
	match event.keycode:
		KEY_BRACKETLEFT:
			activate(active_index - 1)
		KEY_BRACKETRIGHT:
			activate(active_index + 1)
		_:
			return
	
	get_viewport().set_input_as_handled()

func activate(player_index: int) -> void:
	player_index = wrapi(player_index, 0, party.size())
	
	if active_index == player_index:
		return
	
	deactivate()
	active_index = player_index
	get_child(active_index).activate(true)
	player_index_changed.emit(active_index)

func deactivate() -> void:
	if active_index != -1:
		get_child(active_index).activate(false)
		active_index = -1
