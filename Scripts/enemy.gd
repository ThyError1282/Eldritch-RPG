class_name Enemy extends TextureButton

@export var data: BattleActor = null :
	set(value):
		data = value.copy()
		data.hp_changed.connect(_on_data_hp_changed)
		texture_normal = data.sprite
		# etc

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("RESET")

func _on_focus_entered() -> void:
	animation_player.play("highlight")

func _on_focus_exited() -> void:
	animation_player.play("RESET")

func _on_data_hp_changed(hp: int, _hp_max: int, _value_change: int) -> void:
	if hp <= 0:
		hide()
