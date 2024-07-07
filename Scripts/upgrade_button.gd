extends ColorRect

@onready var upgrade_name = $UpgradeName
@onready var upgrade_desc = $Description
@onready var upgrade_lvl = $Level

var mouse_over = false 
var item = null
@onready var player = get_tree().get_first_node_in_group("Player")

signal selected_upgrade(upgrade)

func _ready():
	connect("selected_upgrade", Callable(player, "upgrade_character"))
	if item==null:
		item="HEALTH"
	upgrade_name.text = UpgradesDb.UPGRADES[item]["displayname"]
	upgrade_desc.text = UpgradesDb.UPGRADES[item]["description"]
	upgrade_lvl.text = UpgradesDb.UPGRADES[item]["level"]
	
func _input(event):
	if event.is_action("click") and mouse_over:
			selected_upgrade.emit(item)

func _on_mouse_entered():
	mouse_over = true

func _on_mouse_exited():
	mouse_over = false
