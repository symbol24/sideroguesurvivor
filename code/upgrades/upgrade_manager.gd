class_name UpgradeManager extends Node


@export var upgrade_groups:Array[UpgradeGroup]

var game:Game:
	get:
		if game == null: game = get_tree().get_first_node_in_group(&"GameManager")
		return game


func _ready() -> void:
	name = &"UpgadeManager"
	process_mode = PROCESS_MODE_ALWAYS


func _attempt_purchase(id:StringName, upgrade:Upgrade) -> void:
	var can_buy := true
	
	for currency in upgrade.cost.keys():
		match currency:
			Game.Currency.CURRENCY1:
				if game.player._data.currency1 < upgrade.cost[currency]:
					can_buy = false
			Game.Currency.CURRENCY2:
				if game.player._data.currency2 < upgrade.cost[currency]:
					can_buy = false
			_:
				can_buy = false
	
	if can_buy:
		pass
	else:
		pass