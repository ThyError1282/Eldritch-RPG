class_name PlayerWindow extends Button

var tween: Tween = null

@onready var start_y: float = position.y
@onready var panel_container: PanelContainer = $PanelContainer
@onready var p_name: Label = $PanelContainer/VBoxContainer/PName
@onready var hp: Label = $PanelContainer/VBoxContainer/HP/HP
@onready var mp: Label = $PanelContainer/VBoxContainer/MP/MP

var data: BattleActor = null:
	set(value):
		data = value
		
		if data:
			if data.is_connected("hp_changed", _on_data_hp_changed):
				data.hp_changed.disconnect(_on_data_hp_changed)
			data = value
			data.hp_changed.connect(_on_data_hp_changed)
			p_name.text = data.name.erase(6, 99)
			hp.text = str(data.hp)
			mp.text = str(data.mp)
			show()
		else:
			hide()

func activate(on: bool) -> void:
	var target_y: float = start_y
	var duration: float = 0.5
	
	if on:
		target_y += -8
	
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(panel_container, "position:y", target_y, duration).set_trans(Tween.TRANS_CIRC)

func _on_data_hp_changed(hp: int, _hp_max: int, _value_change: int) -> void:
	self.hp.text = str(hp)
