extends Label

@export var play_sound: bool = true

@onready var coins: AudioStreamPlayer = AudioStreamPlayer.new()

func _ready() -> void:
	add_child(coins)
	coins.name = "Coins"
	coins.stream = preload("res://assets/Textbox/Bump.wav")
	text = str(Data.money)
	
	Data.money_updated.connect(_on_data_money_updated)

func _on_data_money_updated(money: int) -> void:
	text = str(money)
	coins.play()
