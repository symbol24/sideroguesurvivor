class_name Enemy extends Character


const MOVE_SPEED := 50.0


@export var debug_data:EnemyData


var _target:PlayerCharacter
var _direction := 1.0
var move_speed:float:
	get:
		if _data == null: return MOVE_SPEED
		return _data.move_speed


func _ready() -> void:
	add_to_group(&"enemy")
	

func _physics_process(delta: float) -> void:
	if _is_active:
		velocity = _move(velocity, delta)
		move_and_slide()


func setup_character(new_data:CharacterData) -> void:
	_data = new_data.duplicate(true)
	_data.setup_data()
	name = _data.id
	_target = get_tree().get_first_node_in_group(&"player")
	_flip(_target.global_position.x <= global_position.x)
	_direction = -1.0 if _is_facing_left else 1.0
	if debug_data != null: setup_character(debug_data)
	_is_active = true


func damage_death() -> void:
	_is_active = false
	Signals.remove_one.emit(self)
	var tween:Tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.5)
	await tween.finished
	queue_free()


func _death() -> void:
	_is_active = false
	Signals.remove_one.emit(self)
	Signals.spawn_a_gribly.emit(Griblies.Type.COIN, Vector2(global_position.x, global_position.y-48), _data.resource_1_value)
	var tween:Tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.2)
	await tween.finished
	queue_free()


func _move(current_velocity:Vector2, delta:float) -> Vector2:
	var x := clampf(current_velocity.x + (MOVE_SPEED * delta * _direction), -move_speed, move_speed)
	return Vector2(x, current_velocity.y)
