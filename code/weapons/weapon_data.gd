class_name WeaponData extends Resource


@export var id := &""
@export var uid := ""
@export var _starting_damage := 1
@export var _starting_penetration := 1
@export var _starting_weapon_delay := 1.0
@export var _starting_reload_delay := 2.0
@export var _starting_bullet_count := 1

var damage := 1
var penetration := 1
var weapon_delay := 1.0
var reload_delay := 2.0
var bullet_count := 1


func setup_data() -> void:
	damage = _starting_damage
	penetration = _starting_penetration
	weapon_delay = _starting_weapon_delay
	reload_delay = _starting_reload_delay
	bullet_count = _starting_bullet_count
