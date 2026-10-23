class_name Griblies extends Node2D


enum Type {COIN}


const COIN := "uid://dufos5kyb0hl8"


func _ready() -> void:
	name = &"GribliesManager"
	Signals.spawn_a_gribly.connect(_spawn_a_gribly)



func _spawn_a_gribly(type:Type, pos:Vector2, value:int) -> void:
	var to_spawn:Node2D= load(COIN).instantiate()
	match type:
		_:
			pass
	
	add_child(to_spawn)
	if not to_spawn.is_node_ready(): await to_spawn.ready
	to_spawn.global_position = pos
	to_spawn.activate(value)
