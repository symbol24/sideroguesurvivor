class_name PlayerCharacterData extends CharacterData


@export var _starting_invul_time := 0.5


func setup_data() -> void:
	current_lives = _starting_lives
	current_hp = _starting_hp
