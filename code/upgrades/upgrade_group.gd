class_name UpgradeGroup extends Resource


enum Type {DAMAGE, BULLET_COUNT, RELOAD_SPEED, RELOAD_BONUS, SPECIAL_RELOAD, PENETRATION}
enum Calculation {ADDITIVE, MULTIPLICATIVE, LOGARITHMIC}


@export var id := &""
@export var icon_uid := ""
@export var display_name: String
@export var description: String
@export var type: Type
@export var calculation: Calculation
@export var group: Array[Upgrade]

var current_id := 0
var is_maxed: bool:
	get:
		return current_id >= group.size()
var current_upgrade: Upgrade:
	get:
		if is_maxed:
			return null
		return group[current_id]
var current_cost: Array[CurrencyCost]:
	get:
		if is_maxed:
			return []
		return group[current_id].cost
var last_purchased_upgrade: Upgrade:
	get:
		if current_id <= 0:
			return null
		return group[current_id - 1]


func get_current_cost(currency_type: Game.Currency) -> int:
	if is_maxed:
		return 0
	return group[current_id].get_cost(currency_type)


func advance() -> void:
	if not is_maxed:
		current_id += 1


func sync_current_id(unlocked: Dictionary[StringName, StringName]) -> void:
	current_id = 0
	if not unlocked.has(id):
		return

	var latest_upgrade_id: StringName = unlocked[id]
	for i in range(group.size()):
		if group[i].id == latest_upgrade_id:
			current_id = i + 1
			return
