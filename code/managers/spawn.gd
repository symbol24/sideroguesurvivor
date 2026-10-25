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
	_enemies.pop_at(i)


func _toggle_active(value:bool  = false) -> void:
	_is_active = value