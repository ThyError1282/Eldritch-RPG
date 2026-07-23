extends Menu

func _ready() -> void:
	super()
	
	var buttons: Array = get_buttons()
	var party: Array = Data.party
	var party_size: int = Data.party.size()
	for i in get_buttons_count():
		if i < party_size:
			var player: BattleActor = party[i]
			buttons[i].show()
			buttons[i].text = player.name
		else:
			buttons[i].hide()
