class_name PlayerCharacterData extends CharacterData


@export var _starting_invul_time := 0.5
@export var _starting_weapon_delay := 1.0
@export var _debug_bullet_count := 1
@export var _debug_weapon_reload_delay := 2.0
@export var _starting_damage := 1
@export var _starting_penetration := 1

var invulnerable_time := 0.0
var weapon_delay := 1.0
var weapon_reload_delay := 2.0
var bullet_count := 1
var damage := 1
var penetration := 1


func setup_data() -> void:
	current_lives = _starting_lives
	current_hp = _starting_hp
	invulnerable_time = _starting_invul_time
	weapon_delay = _starting_weapon_delay
	weapon_reload_delay = _debug_weapon_reload_delay
	bullet_count = _debug_bullet_count
	damage = _starting_damage
	penetration = _starting_penetration


func recalculate_upgrades(upgrade_groups: Array[UpgradeGroup]) -> void:
	setup_data()
	for group in upgrade_groups:
		if group == null:
			continue
		for i in range(group.current_id):
			_apply_upgrade(group.group[i], group.type, group.calculation)


func apply_upgrade_group(group: UpgradeGroup) -> void:
	if group == null or group.last_purchased_upgrade == null:
		return
	_apply_upgrade(group.last_purchased_upgrade, group.type, group.calculation)


func _apply_upgrade(upgrade: Upgrade, type: UpgradeGroup.Type, calc: UpgradeGroup.Calculation) -> void:
	assert(upgrade != null, "Upgrade received by player character data is null")
	var val := float(upgrade.value)

	match type:
		UpgradeGroup.Type.DAMAGE:
			damage = max(1, int(round(_calculate(float(damage), val, calc))))
		UpgradeGroup.Type.BULLET_COUNT:
			bullet_count = max(1, int(round(_calculate(float(bullet_count), val, calc))))
		UpgradeGroup.Type.RELOAD_SPEED:
			weapon_reload_delay = max(0.05, _calculate(weapon_reload_delay, val, calc))
		UpgradeGroup.Type.RELOAD_BONUS:
			pass
		UpgradeGroup.Type.SPECIAL_RELOAD:
			pass
		UpgradeGroup.Type.PENETRATION:
			penetration = max(1, int(round(_calculate(float(penetration), val, calc))))


func _calculate(current: float, mod: float, calc: UpgradeGroup.Calculation) -> float:
	match calc:
		UpgradeGroup.Calculation.ADDITIVE:
			return current + mod
		UpgradeGroup.Calculation.MULTIPLICATIVE:
			return current * mod
		UpgradeGroup.Calculation.LOGARITHMIC:
			return current + log(mod + 1.0)
	return current
