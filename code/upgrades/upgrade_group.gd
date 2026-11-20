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
		if is_maxed: return null
		assert(group[current_id] != null, "Upgrade %s for group %s is null." % [current_id, id])
		return group[current_id]
var current_cost: Array[CurrencyCost]:
	get:
		if is_maxed or group[current_id] == null: return []
		return group[current_id].cost
var last_purchased_upgrade: Upgrade:
	get:
		if current_id <= 0: return null
		return group[current_id - 1]


func get_current_cost(currency_type: Game.Currency) -> int:
	if is_maxed or group[current_id] == null:
		return 0
	return group[current_id].get_cost(currency_type)


func advance() -> void:
	if not is_maxed:
		current_id += 1


func sync_current_id(unlocked: Dictionary[StringName, int]) -> void:
	if not unlocked.has(id): return
	current_id = 0
	current_id = clampi(unlocked[id], 0, group.size())
