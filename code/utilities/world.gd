class_name World extends Node2D


const DEBUG_ENEMY := preload("uid://drsdxd6nl0fvt")
const TIMER := 2.0


@export var left_spawn:Marker2D
@export var right_spawn:Marker2D

var _debug_timer := 0.0:
	set(value):
		_debug_timer = value
		if _debug_timer <= 0.0:
			Signals.spawn_one.emit(DEBUG_ENEMY, true if randf() <= 0.5 else false)
			_debug_timer = TIMER
			


func _ready() -> void:
	var sm:Spawn = Spawn.new()
	add_child(sm)
	if not sm.is_node_ready(): await sm.ready
	Signals.toggle_display.emit(&"play_ui", true)
	

func _process(delta: float) -> void:
	_debug_timer -= delta