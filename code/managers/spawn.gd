class_name Spawn extends Node2D


var _world:World:
	get:
		if _world == null: _world = get_parent()
		return _world
var _enemies:Array[Enemy] = []
var _active_character:PlayerCharacter
var _is_active := false


func _ready() -> void:
	name = &"SpawnManager"
	add_to_group(&"SpawnManager")
	Signals.spawn_one.connect(_spawn)
	Signals.remove_one.connect(_remove_enemy)
	Signals.toggle_active.connect(_toggle_active)
	Signals.spawn_character.connect(_spawn_character)


func _spawn(_data:EnemyData, _is_left:bool = true) -> void:
	if _is_active:
		var enemy:Enemy = load(_data.scene).instantiate()
		_world.add_child(enemy)
		enemy.global_position = _world.left_spawn.global_position if _is_left else _world.right_spawn.global_position
		if not enemy.is_node_ready(): await enemy.ready
		enemy.setup_character(_data)
		_enemies.append(enemy)
		enemy.toggle_active(true)


func _spawn_character(_character_player_data:PlayerCharacterData, _position:Vector2 = Game.PLAYER_POS) -> void:
	assert(_character_player_data!=null, "Missing PlayerCharacterData for spawn manager")
	_active_character = load(_character_player_data.scene).instantiate()
	_world.add_child(_active_character)
	if not _active_character.is_node_ready(): await _active_character.ready
	_active_character.setup_character(_character_player_data)
	_active_character.global_position = _position


func _remove_enemy(enemy: Enemy) -> void:
	var i := _enemies.find(enemy)
	if i != -1: _enemies.pop_at(i)


func _toggle_active(value:bool  = false) -> void:
	_is_active = value
	# If the round is ending/pausing, clear out all active enemies immediately
	if not _is_active: _clear_all_enemies()


func _clear_all_enemies() -> void:
	for enemy in _enemies.duplicate():
		if is_instance_valid(enemy):
			enemy.queue_free()
	_enemies.clear()


func get_targets_in_line(player_pos: Vector2, facing_left: bool, max_range: float = INF, max_targets: int = 1) -> Array[Enemy]:
	var candidates: Array[Enemy] = []

	for enemy in _enemies:
		if enemy == null or not is_instance_valid(enemy) or not enemy._is_active:
			continue

		var dx := enemy.global_position.x - player_pos.x
		if facing_left and dx > 0.0:
			continue
		if not facing_left and dx < 0.0:
			continue

		var dist := absf(dx)
		if dist > max_range:
			continue

		candidates.append(enemy)

	candidates.sort_custom(func(a: Enemy, b: Enemy) -> bool:
		return absf(a.global_position.x - player_pos.x) < absf(b.global_position.x - player_pos.x)
	)

	if max_targets > 0 and candidates.size() > max_targets:
		candidates.resize(max_targets)

	return candidates