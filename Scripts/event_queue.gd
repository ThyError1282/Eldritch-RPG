class_name EventQueue extends Node

enum Actions {
	FIGHT,
	DEFEND,
	ITEM,
}

const SHORT: float = 0.75
const LONG: float = 1.25

var events: Array[Dictionary] = []

@onready var textbox: Textbox = Globals.textbox

func add(action: Actions, actor: BattleActor, target: BattleActor, item: Item) -> void:
	events.append({"action": action, "actor": actor, "target": target, "item": item})

func pop_back() -> void:
	events.pop_back()

func shuffle() -> void:
	events.shuffle()

func wait(duration: float) -> void:
	await(get_tree().create_timer(duration).timeout)

func run() -> void:
	if events.is_empty():
		textbox.stop()
		return
	
	var event: Dictionary = events.pop_front()
	var action: Actions = event.action
	var actor: BattleActor = event.actor
	var target: BattleActor = event.target
	var item: Item = event.item
	var text: String = actor.name
	var party: Array = Data.party.duplicate()
	var target_is_friendly: bool = party.has(target)
	
	if not actor.can_act():
		await(run())
		return
	
	if target.is_defeated():
		var targets: Array = party
		
		if not target_is_friendly:
			# obtain enemy data
			targets.clear()
			for v: Enemy in get_tree().get_nodes_in_group("enemies"):
				targets.append(v.data)
		
		# find first valid target in shuffled targets
		target = null
		targets.shuffle()
		for v: BattleActor in targets:
			if not v.is_defeated():
				target = v
				break
		
		if not target:
			# no more valid targets on this side.
			# TODO this only makes sense for when we are attacking the other side.
			# Needs better expansion of logic.
			return
	
	#print("Running Event: ", actor.name, " is ", Actions.keys()[event.action], " ", target.name, ".")
	
	match action:
		Actions.FIGHT:
			var damage: int = actor.damage_roll(target)
			text += " attacks " + target.name + "..."
			textbox.start("", [text])
			await(wait(SHORT))
			
			target.healhurt(damage)
			if target_is_friendly:
				Globals.screen_shake.add_trauma(2.5)
			if damage > 0:
				textbox.add("... but " + target.name + " evades.")
			else:
				textbox.add("... " + target.name + " takes " + str(abs(damage)) + " damage!!")
		Actions.ITEM:
			if target.name == actor.name:
				text += " uses " + item.name + " on themselves ..."
			else:
				text += " uses " + item.name + " on " + target.name + " ..."
			textbox.start("", [text])
			await(wait(SHORT))
			textbox.add("... but this is not implemented yet :(")
		_:
			pass
	
	await(wait(LONG))
	
	if target.is_defeated():
		textbox.add(target.name + " has lost their will to continue.")
		await(wait(LONG))
	
	await(run())
