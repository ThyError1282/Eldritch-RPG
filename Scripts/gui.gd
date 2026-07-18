class_name GUI extends CanvasLayer

@onready var top_menu: Menu = $Control/MarginContainer/TopMenu

func _ready() -> void:
	hide()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.pressed and event.keycode == KEY_M:
		visible = !visible
		get_tree().paused = visible
		if visible:
			top_menu.button_focus(0)

func _on_top_menu_button_pressed(button: BaseButton, index: int) -> void:
	match button.text:
		"Quit":
			get_tree().quit()
		_:
			pass
