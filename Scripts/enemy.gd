class_name Enemy extends TextureButton

@export var data: BattleActor = null :
	set(value):
		data = value.copy()
		data.hp_changed.connect(_on_data_hp_changed)
		texture_normal = data.sprite
		# etc

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hit_flash: Timer = $HitFlash

func _ready() -> void:
	animation_player.play("RESET")

func _process(_delta: float) -> void:
	if not hit_flash.is_stopped():
		modulate.a = randf()

func _on_focus_entered() -> void:
	animation_player.play("highlight")

func _on_focus_exited() -> void:
	animation_player.play("RESET")

func _on_data_hp_changed(hp: int, _hp_max: int, value_change: int) -> void:
	if value_change < 0:
		hit_flash.start()
		await(hit_flash.timeout)
	
	if hp <= 0:
		var tween: Tween = create_tween()
		tween.tween_property(self, "modulate:a", 0.0, 0.5).set_trans(Tween.TRANS_QUART)
		await(tween.finished)
		hide()

func _on_hit_flash_timeout() -> void:
	modulate.a = 1.0
