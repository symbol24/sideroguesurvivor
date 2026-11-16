class_name BuyButton extends Control


@export var upgrade_data:UpgradeGroup

@onready var icon:TextureRect = %icon
@onready var resource_1:Label = %resource_1
@onready var count:Label = %count


func _ready() -> void:
	assert(upgrade_data != null, name + " does not contain an upgrade group!")


func set_state() -> void:
	if upgrade_data.icon_uid != "": icon.texture = load(upgrade_data.icon_uid)
	count.text = str(upgrade_data.current_id) + "/" + str(upgrade_data.group.size())
	print(upgrade_data.group[0].cost)
	resource_1.text = str(upgrade_data.current_cost[Game.Currency.CURRENCY1]) if upgrade_data.current_cost.has(Game.Currency.CURRENCY1) else "0"
