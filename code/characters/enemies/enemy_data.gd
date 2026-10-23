class_name EnemyData extends CharacterData


@export var _starting_move_speed := 50.0
@export var _starting_damage := 1
@export var _starting_resource_1_value := 1

var move_speed:float
var damage:int
var resource_1_value:int


func setup_data() -> void:
	current_lives = _starting_lives
	current_hp = _starting_hp
	move_speed = _starting_move_speed
	damage = _starting_damage
	resource_1_value = _starting_resource_1_value