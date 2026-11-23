class_name PlayerCharacter extends Character


const DELAY_CHECK_TIMER := 0.05
const INPUT_DELAY := 0.2
const DEBUG_WEAPON_DELAY := 1.0


@export var debug_data: PlayerCharacterData
@export var gun_point:Marker2D

var data:PlayerCharacterData:
	get:
		return _data
	set(value):
		pass
var _spawn_manager:Spawn:
	get:
		if _spawn_manager == null: _spawn_manager = get_tree().get_first_node_in_group(&"SpawnManager") as Spawn
		return _spawn_manager
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
		elif event.is_action_pressed(&"right"):
			_right_pressed = true
			_button_check()
			get_viewport().set_input_as_handled()


func _ready() -> void:
	super()
	add_to_group(&"player")
	Signals.reload_timer_complete.connect(_reload_time_complete)
	Signals.upgrade_purchased.connect(_on_upgrade_purchased)


func _process(delta: float) -> void:
	if _is_active:
		if _check_timer > 0.0: _check_timer -= delta
		if _input_timer > 0.0: _input_timer -= delta
		if _attack_timer > 0.0: _attack_timer -= delta


func setup_character(new_data: CharacterData) -> void:
	await super(new_data)
	if _data is PlayerCharacterData:
		var um := get_tree().get_first_node_in_group(&"UpgradeManager") as UpgradeManager
		if um != null:
			(_data as PlayerCharacterData).recalculate_upgrades(um.upgrade_groups)
		_max_bullet_amount = _data.get_bullet_count()
		_current_bullet_count = _max_bullet_amount
		_setup_weapon()


func _setup_weapon() -> void:
	assert(data.weapon != null, "Weapon data missing from PlayerCharacterData " + data.id)
	var new:Node2D = load(data.weapon.uid).instantiate()
	add_child.call_deferred(new)
	if not new.is_node_ready(): await new.ready
	new.position = gun_point.position
	

func _trigger_direction() -> void:
	if _left_pressed and _right_pressed: return
	elif not _left_pressed and not _right_pressed: return
	if _left_pressed:
		_flip(true)
	elif _right_pressed:
		_flip(false)
	if _can_shoot and _current_bullet_count > 0:
		var enemy: Array[Enemy] = _get_target()
		if not enemy.is_empty():
			var dmg: int = _data.get_weapon_damage() if _data is PlayerCharacterData else 1
			for each in enemy:
				each.apply_damage(-dmg)
		_can_shoot = false
		_attack_timer = _data.get_weapon_delay() if _data is PlayerCharacterData else DEBUG_WEAPON_DELAY
		_current_bullet_count -= 1
		Signals.shots_fired.emit(_current_bullet_count)
	_reset_inputs()


func _trigger_double() -> void:
	_input_timer = INPUT_DELAY
	Signals.start_reload_timer.emit(_data.get_weapon_reload_delay())
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


func _get_target() -> Array[Enemy]:
	if _spawn_manager != null:
		var pen: int = _data.get_weapon_penetration() if _data is PlayerCharacterData else 1
		var targets: Array[Enemy] = _spawn_manager.get_targets_in_line(
				global_position,
				_is_facing_left,
				INF,
				pen
		)
		return targets
	return []


func _round_end_cleanup() -> void:
	_left_pressed = false
	_right_pressed = false
	_input_timer = 0.0
	_check_timer = 0.0
	_attack_timer = 0.0


func _on_upgrade_purchased(group: UpgradeGroup) -> void:
	if _data is PlayerCharacterData:
		var p_data := _data as PlayerCharacterData
		p_data.apply_upgrade_group(group)
		_max_bullet_amount = p_data.get_bullet_count()
		_current_bullet_count = _max_bullet_amount


func _death() -> void:
	Signals.player_dead.emit()