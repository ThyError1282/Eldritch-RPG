extends Node

const GAME_SIZE: Vector2 = Vector2(1152,648)
const GAME_SIZE_HALVED: Vector2 = GAME_SIZE * 0.5
const CELL_SIZE: Vector2 = Vector2(32,32)
const NULL_CELL: Vector2 = Vector2(-9999,-9999)

var cursor: Node = null
var camera : Camera2D = null
var cell_size: Vector2 = Vector2(0,0)
var event_log: Label = null
var menu_has_focus: bool = false
var textbox: Textbox = null
var screen_shake: ScreenShake2D
var player: CharacterBody2D = null
var clock: Label

func _ready():
	randomize()
