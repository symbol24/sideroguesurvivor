class_name PlayerCharacter extends Character


const DELAY_CHECK_TIMER := 0.02
const INPUT_DELAY := 0.2


@export var debug_data:PlayerCharacterData
@export var attack_detector:RayCast2D


var _input_timer := 0.0:
	set(value):
		_input_timer = value
		if _input_timer <= 0.0:
			_input_timer = 0.0
			_reset_inputs()
var _check_timer := 0.0:
	set(value):
		_check_timer = value
		if _check_timer <= 0.0: 
			_check_timer = 0.0
			_trigger_direction()
var _left_pressed := false
var _right_pressed := false	


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"left"):
		if _check_timer <= 0.0:
			_left_pressed = true
			_start_check_timer()
			return
		else:
			if _right_pressed: _trigger_double()
	elif event.is_action_pressed(&"right"):
		if _check_timer <= 0.0:
			_right_pressed = true
			_start_check_timer()
			return
		else:
			if _left_pressed: _trigger_double()


func _ready() -> void:
	add_to_group(&"player")
	if debug_data != null: setup_character(debug_data)


func _process(delta: float) -> void:
	if _check_timer > 0.0: _check_timer -= delta
	if _input_timer > 0.0: _input_timer -= delta


func _trigger_direction() -> void:
	if _left_pressed: 
		_flip(true)
	elif _right_pressed: 
		_flip(false)
	var enemy:Enemy = _get_target()
	if enemy != null: enemy.apply_damage(-1)
	_reset_inputs()


func _trigger_double() -> void:
	_input_timer = INPUT_DELAY
	_left_pressed = false
	_right_pressed = false
	print("Double action triggered")


func _start_check_timer() -> void:
	if _check_timer > 0.0: return
	_check_timer = DELAY_CHECK_TIMER


func _reset_inputs() -> void:
	_left_pressed = false
	_right_pressed = false


func _get_target() -> Enemy:
	var enemy:Enemy
	attack_detector.force_raycast_update()
	enemy = attack_detector.get_collider()
	return enemy