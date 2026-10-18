class_name HitCollider extends Area2D


var _parent:Character:
	get:
		if _parent == null: _parent = get_parent()
		return _parent

@onready var collision:CollisionShape2D = %hit_collision


func get_damage() -> int:
	_parent.damage_death()
	return _parent.damage