class_name CharacterData extends Resource


@export var id := &""
@export var scene := ""
@export var _starting_hp := 1
@export var _starting_lives := 1

var current_lives := 1
var current_hp := 1


func setup_data() -> void:
	pass


func update_hp(value :=  0) -> void:
	current_hp = maxi(current_hp + value, 0)


func update_lives(value := -1) -> void:
	current_lives = maxi(current_lives + value, 0)
	