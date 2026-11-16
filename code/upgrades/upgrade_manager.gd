class_name UpgradeManager extends Node

@export var upgrade_groups: Array[UpgradeGroup] = []

var game: Game:
	get:
		if game == null:
			game = get_tree().get_first_node_in_group(&"GameManager")
		return game


func _ready() -> void:
	name = &"UpgradeManager"
	add_to_group(&"UpgradeManager")
	process_mode = PROCESS_MODE_ALWAYS
	Signals.attempt_purchase.connect(_attempt_purchase)
	Signals.load_complete.connect(_on_load_complete)


func _on_load_complete(data: SaveData) -> void:
	if data == null:
		return
	for group in upgrade_groups:
		if group != null:
			group.sync_current_id(data.unlocked_upgrades)


func _attempt_purchase(group: UpgradeGroup) -> void:
	if group == null or group.is_maxed or game == null or game.save_data == null:
		return

	var upgrade := group.current_upgrade
	if upgrade == null:
		return

	# 1. Check if player can afford all CurrencyCost entries
	for entry in upgrade.cost:
		if entry == null:
			continue
		match entry.currency:
			Game.Currency.CURRENCY1:
				if game.save_data.currency_1 < entry.amount:
					print("Unable to purchase ", upgrade.id)
					return
			Game.Currency.CURRENCY2:
				if game.save_data.currency_2 < entry.amount:
					return
			_:
				return

	# 2. Deduct currencies
	for entry in upgrade.cost:
		if entry == null:
			continue
		match entry.currency:
			Game.Currency.CURRENCY1:
				Signals.update_resource_1.emit(-entry.amount)
				print("Upgrade " + upgrade.id + " purchased!")
			Game.Currency.CURRENCY2:
				game.save_data.currency_2 -= entry.amount

	# 3. Advance tier & broadcast signal (Game saves unlocked_upgrades on upgrade_purchased)
	group.advance()
	Signals.upgrade_purchased.emit(group)
