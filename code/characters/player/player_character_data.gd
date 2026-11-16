class_name PlayerCharacterData extends CharacterData


@export var _starting_invul_time := 0.5
@export var _starting_weapon_delay := 1.0
@export var _debug_bullet_count := 1
@export var _debug_weapon_reload_delay := 2.0

# Run data
@export_category(&"Run Data")
@export var currency1 := 0
@export var currency2 := 0
@export var unlocked_upgrades:Dictionary[StringName, Upgrade]

var invul_time := 0.0
var weapon_delay := 1.0
var weapon_reload_delay := 2.0
var bullet_count := 1.0
var damage := 1


func setup_data() -> void:
	current_lives = _starting_lives
	current_hp = _starting_hp
	invul_time = _starting_invul_time
	weapon_delay = _starting_weapon_delay
	weapon_reload_delay = _debug_weapon_reload_delay
	bullet_count = _debug_bullet_count


func add_upgrade(new_upgrade:Upgrade, type:UpgradeGroup.Type) -> void:
	assert(new_upgrade != null, "Upgrade received by player character data is null")
	if unlocked_upgrades.has(new_upgrade.id): return
	unlocked_upgrades[new_upgrade.id] = new_upgrade
	match type:
		UpgradeGroup.Type.RELOAD_SPEED:
			weapon_reload_delay += new_upgrade.value
		_:
			pass