class_name PlayerCharacterData extends CharacterData


@export var _starting_invul_time := 0.5
@export var _starting_damage := 0
@export var _starting_penetration := 0
@export var _starting_weapon_delay := 0.0
@export var _starting_weapon_reload_delay := 0.0
@export var _starting_bullet_count := 0
@export var weapon: WeaponData

var invulnerable_time := 0.0
var _base_damage := 0
var _base_penetration := 0
var _base_weapon_delay := 0.0
var _base_weapon_reload_delay := 0.0
var _base_bullet_count := 0

var damage: int:
	get:
		var w := weapon.damage if weapon != null else 1
		return _base_damage + w
var penetration: int:
	get:
		var w := weapon.penetration if weapon != null else 1
		return _base_penetration + w
var weapon_delay: float:
	get:
		var w := weapon.weapon_delay if weapon != null else 1.0
		return _base_weapon_delay + w
var weapon_reload_delay: float:
	get:
		var w := weapon.reload_delay if weapon != null else 2.0
		return _base_weapon_reload_delay + w
var bullet_count: int:
	get:
		var w := weapon.bullet_count if weapon != null else 1
		return _base_bullet_count + w


func setup_data() -> void:
	super()
	invulnerable_time = _starting_invul_time
	_base_damage = _starting_damage
	_base_penetration = _starting_penetration
	_base_weapon_delay = _starting_weapon_delay
	_base_weapon_reload_delay = _starting_weapon_reload_delay
	_base_bullet_count = _starting_bullet_count
	if weapon != null:
		weapon.setup_data()


func get_weapon_damage() -> int:
	return damage


func get_weapon_penetration() -> int:
	return penetration


func get_weapon_delay() -> float:
	return weapon_delay


func get_weapon_reload_delay() -> float:
	return weapon_reload_delay


func get_bullet_count() -> int:
	return bullet_count


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
	assert(weapon != null, "Weapon data is null when applying upgrade")
	var val := float(upgrade.value)

	match type:
		UpgradeGroup.Type.DAMAGE:
			weapon.damage = max(1, int(round(_calculate(float(weapon.damage), val, calc))))
		UpgradeGroup.Type.BULLET_COUNT:
			weapon.bullet_count = max(1, int(round(_calculate(float(weapon.bullet_count), val, calc))))
		UpgradeGroup.Type.RELOAD_SPEED:
			weapon.reload_delay = max(0.05, _calculate(weapon.reload_delay, val, calc))
		UpgradeGroup.Type.RELOAD_BONUS:
			pass
		UpgradeGroup.Type.SPECIAL_RELOAD:
			pass
		UpgradeGroup.Type.PENETRATION:
			weapon.penetration = max(1, int(round(_calculate(float(weapon.penetration), val, calc))))


func _calculate(current: float, mod: float, calc: UpgradeGroup.Calculation) -> float:
	match calc:
		UpgradeGroup.Calculation.ADDITIVE:
			return current + mod
		UpgradeGroup.Calculation.MULTIPLICATIVE:
			return current * mod
		UpgradeGroup.Calculation.LOGARITHMIC:
			return current + log(mod + 1.0)
	return current
