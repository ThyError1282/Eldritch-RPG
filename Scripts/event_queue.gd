class_name EventQueue extends Node

enum Actions {
	FIGHT,
	DEFEND,
	ITEM,
}

var events: Array[Dictionary] = []

@onready var textbox: Textbox = Globals.textbox

func add(action: Actions, actor: BattleActor, target: BattleActor) -> void:
	events.append({"action": action, "actor": actor, "target": target})
	#print("Adding Event: ", actor.name, " is ", Actions.keys()[action], " ", target.name, ".")

func pop_back() -> void:
	events.pop_back()

func run() -> void:
	if events.is_empty():
		textbox.stop()
		return
	
	var event: Dictionary = events.pop_front()
	var action: Actions = event.action
	var actor: BattleActor = event.actor
	var target: BattleActor = event.target
	
	#print("Running Event: ", actor.name, " is ", Actions.keys()[event.action], " ", target.name, ".")
	
	match event.action:
		Actions.FIGHT:
			var damage: int = target.healhurt(-1)
			textbox.start("", [actor.name + " attacks " + target.name + " for " + str(abs(damage)) + " damage!!"])
			await(get_tree().create_timer(0.5).timeout)
			textbox.add(target.name + " takes " + str(abs(damage)) + " damage!!")
		_:
			pass
	
	await(get_tree().create_timer(0.5).timeout)
	await(run())
