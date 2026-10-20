class_name PlayerCharacterData extends CharacterData


@export var _starting_invul_time := 0.5
@export var _starting_weapon_delay := 1.0
@export var _debug_bullet_count := 1
@export var _debug_weapon_reload_delay := 2.0

var invul_time := 0.0
var weapon_delay := 1.0
var weapon_reload_delay := 2.0
var bullet_count := 1.0


func setup_data() -> void:
	current_lives = _starting_lives
	current_hp = _starting_hp
	invul_time = _starting_invul_time
	weapon_delay = _starting_weapon_delay
	weapon_reload_delay = _debug_weapon_reload_delay
	bullet_count = _debug_bullet_count