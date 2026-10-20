class_name Character extends CharacterBody2D


var _data:CharacterData
var _is_active := false
var _is_facing_left := false
var _invulnerable := false
var _invulnerable_time:float:
	get:
		if _data != null and _data.get(&"invulnerable_time"): return _data.inveulnerable_time
		return 1.0
var damage:int:
	get:
		if _data == null: return 1
		return _data.damage


func setup_character(new_data:CharacterData) -> void:
	_data = new_data.duplicate(true)
	_data.setup_data()
	if not is_node_ready(): await ready
	name = _data.id
	_is_active = true


func apply_damage(value:int = 0) -> void:
	if not _invulnerable:
		toggle_invulnerable(true)
		_data.update_hp(value)
		if _data.current_hp <= 0:
			_data.update_lives()
			if _data.current_lives <= 0:
				_death()

	
func toggle_invulnerable(value:bool = false) -> void:
	_invulnerable = value
	if value: get_tree().create_timer(_invulnerable_time).timeout.connect(toggle_invulnerable)


func _flip(is_left:bool = true) -> void:
	if is_left:
		if not _is_facing_left:
			scale.x = -1.0
			_is_facing_left = true
	else:
		if _is_facing_left:
			scale.x = 1.0
			_is_facing_left = false


func _death() -> void:
	queue_free()
