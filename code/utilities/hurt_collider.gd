class_name HurtCollider extends Area2D


var _parent:Character:
	get:
		if _parent == null: _parent = get_parent()
		return _parent

@onready var collision:CollisionShape2D = %hurt_collision


func _ready() -> void:
	area_entered.connect(_area_entered)


func _area_entered(area:Area2D) -> void:
	if area is HitCollider:
		_parent.apply_damage(-area.get_damage())
