class_name PlayerCharacter extends Character


const DELAY_CHECK_TIMER := 0.05
const INPUT_DELAY := 0.2
const DEBUG_WEAPON_DELAY := 1.0


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
var _attack_timer := 0.0:
	set(value):
		_attack_timer = value
		if _attack_timer <= 0.0:
			_attack_timer = 0.0
			_can_shoot = true
var _can_shoot := true
var _left_pressed := false
var _right_pressed := false
var _max_bullet_amount := 1
var _current_bullet_count := 1


func _input(event: InputEvent) -> void:
	if _is_active:
		if event.is_action_pressed(&"left"):
			_left_pressed = true
			_button_check()
			get_viewport().set_input_as_handled()
			print("left")
		elif event.is_action_pressed(&"right"):
			_right_pressed = true
			_button_check()
			get_viewport().set_input_as_handled()
			print("right")


func _ready() -> void:
	super()
	add_to_group(&"player")
	Signals.reload_timer_complete.connect(_reload_time_complete)
	Signals.new_upgrade.connect(_new_upgrade)


func _process(delta: float) -> void:
	if _is_active:
		if _check_timer > 0.0: _check_timer -= delta
		if _input_timer > 0.0: _input_timer -= delta
		if _attack_timer > 0.0: _attack_timer -= delta


func setup_character(new_data:CharacterData) -> void:
	_data = new_data.duplicate(true)
	_data.setup_data()
	if not is_node_ready(): await ready
	name = _data.id
	_max_bullet_amount = _data.bullet_count
	_current_bullet_count = _max_bullet_amount


func _trigger_direction() -> void:
	if _left_pressed and _right_pressed: return
	elif not _left_pressed and not _right_pressed: return
	if _left_pressed: 
		_flip(true)
	elif _right_pressed: 
		_flip(false)
	if _can_shoot and _current_bullet_count > 0:
		var enemy:Enemy = _get_target()
		if enemy != null: enemy.apply_damage(-1)
		_can_shoot = false
		_attack_timer = _data.weapon_delay if _data != null else DEBUG_WEAPON_DELAY
		_current_bullet_count -= 1
		Signals.shots_fired.emit(_current_bullet_count)
	_reset_inputs()


func _trigger_double() -> void:
	_input_timer = INPUT_DELAY
	Signals.start_reload_timer.emit(_data.weapon_reload_delay)
	get_tree().create_timer(DELAY_CHECK_TIMER).timeout.connect(_reset_inputs)


func _reload_time_complete() -> void:
	_current_bullet_count = _max_bullet_amount


func _button_check() -> void:
	if _check_timer > 0.0:
		if _left_pressed and _right_pressed:
			_trigger_double()
	else:
		_check_timer = DELAY_CHECK_TIMER
	

func _reset_inputs() -> void:
	_left_pressed = false
	_right_pressed = false


func _get_target() -> Enemy:
	var enemy:Enemy
	attack_detector.force_raycast_update()
	enemy = attack_detector.get_collider()
	return enemy


func _update_resource_1(value:int) -> void:
	_data.currency1 += value
	Signals.resource_1_updated.emit(_data.currency1)


func _round_end_cleanup() -> void:
	_left_pressed = false
	_right_pressed = false
	_input_timer = 0.0
	_check_timer = 0.0
	_attack_timer = 0.0


func _new_upgrade(new_upgrade:Upgrade, type:UpgradeGroup.Type) -> void:
	_data.add_upgrade(new_upgrade, type)