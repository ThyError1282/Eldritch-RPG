extends Control

const Actions: Dictionary = EventQueue.Actions

var party: Array = Data.party
var action: EventQueue.Actions = -1
var current_player_index: int = -1

@onready var event_queue: EventQueue = $EventQueue
@onready var options: Menu = $MarginContainer/Options
@onready var enemies: Menu = $Enemies
@onready var player_windows: PlayerWindows = $MarginContainer/PlayerWindows
@onready var textbox: PanelContainer = $MarginContainer/Textbox

func _ready() -> void:
	goto_next_player()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if enemies.close() or player_windows.close():
			options.button_focus()
		elif current_player_index > 0 and options.menu_is_focused():
			event_queue.pop_back()
			goto_next_player(-1)
		else:
			return
		
		get_viewport().set_input_as_handled()

func goto_next_player(dir: int = 1) -> void:
	current_player_index += dir
	
	if current_player_index >= party.size():
		for enemy: Enemy in enemies.get_buttons():
			var actor: BattleActor = enemy.data
			var target: BattleActor = party.pick_random() # TODO actual AI based targetting
			event_queue.add(Actions.FIGHT, actor, target) # TODO picking actions
		
		# TODO sort by speed rolls
		options.hide()
		enemies.release()
		player_windows.activate(-1)
		await(event_queue.run())
		current_player_index = 0
	
	action = -1
	player_windows.activate(current_player_index)
	options.button_focus()

func _on_options_button_pressed(button: BaseButton, _index: int) -> void:
	
	match button.text:
		"Fight":
			action = Actions.FIGHT
			enemies.button_focus()
		_:
			pass

func _on_enemies_button_pressed(button: BaseButton, index: int) -> void:
	# send actions to event queue
	var actor: BattleActor = party[current_player_index]
	var target: BattleActor = button.data
	event_queue.add(action, actor, target)
	goto_next_player()
