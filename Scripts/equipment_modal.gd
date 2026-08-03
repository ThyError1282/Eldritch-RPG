class_name EquipmentModal extends Menu

@onready var items: InventoryMenu = $Equipment/Equipped/Info/Items
@onready var stock: InventoryMenu = $Equipment/Stock/Stock

var actor: BattleActor = null
var current_slot: int = -1
var current_action: String = ""

func _ready() -> void:
	super()
