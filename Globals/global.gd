extends Node

enum States {
	FIELD,
	BATTLE,
}

const GAME_SIZE: Vector2 = Vector2(1152,648)
const GAME_SIZE_HALVED: Vector2 = GAME_SIZE * 0.5
const CELL_SIZE: Vector2 = Vector2(8,8)
const NULL_CELL: Vector2 = Vector2(-9999,-9999)

var current_map: TileMapLayer = null
var player: Player = null
var clock: Clock = Clock.new()
var target_cell: Vector2 = Vector2.ZERO
var textbox: Textbox = null
var camera : Camera2D = null
var screen_shake: ScreenShake2D
var music_position: float = 0.0
var cell_size: Vector2 = Vector2(0,0)
var state: int = 0
var grid_cursor: GridCursor = null
var event_log: Label = null
var menu_has_focus: bool = false
var cursor: Node = null
var transition_handler: Node = null

func _ready():
	randomize()
	process_mode = PROCESS_MODE_ALWAYS
	#Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	clock.visible = false
	clock.INGAME_SPEED = 15.0
	add_child(clock)
