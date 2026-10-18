class_name Spawn extends Node2D


var _world:World:
	get:
		if _world == null: _world = get_parent()
		return _world
var _enemies:Array[Enemy] = []


func _ready() -> void:
	name = &"SpawnManager"
	Signals.spawn_one.connect(_spawn)
	Signals.remove_one.connect(_remove_enemy)


func _spawn(_data:EnemyData, _is_left:bool = true) -> void:
	var enemy:Enemy = load(_data.scene).instantiate()
	_world.add_child(enemy)
	enemy.global_position = _world.left_spawn.global_position if _is_left else _world.right_spawn.global_position
	if not enemy.is_node_ready(): await enemy.ready
	enemy.setup_character(_data)
	_enemies.append(enemy)


func _remove_enemy(enemy: Enemy) -> void:
	var i := _enemies.find(enemy)
	_enemies.pop_at(i)