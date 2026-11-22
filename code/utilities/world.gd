class_name World extends Node2D


const DEBUG_ENEMY := preload("uid://drsdxd6nl0fvt")
const DEBUG_PLAYER := preload("uid://s6kbt5sqli2s")
const TIMER := 2.0


@export var left_spawn:Marker2D
@export var right_spawn:Marker2D

var _active := false
var _debug_timer := 0.0:
	set(value):
		_debug_timer = value
		if _debug_timer <= 0.0:
			Signals.spawn_one.emit(DEBUG_ENEMY, true if randf() <= 0.5 else false)
			_debug_timer = TIMER
			

func _ready() -> void:
	Signals.toggle_active.connect(_toggle_active)
	Signals.player_ready.connect(_player_ready)
	var sm:Spawn = Spawn.new()
	add_child(sm)
	if not sm.is_node_ready(): await sm.ready
	var griblies := Griblies.new()
	add_child(griblies)
	if not griblies.is_node_ready(): await griblies.ready
	Signals.spawn_character.emit(DEBUG_PLAYER, Game.PLAYER_POS)
	
	
func _process(delta: float) -> void:
	if _active: _debug_timer -= delta


func _toggle_active(value:bool) -> void:
	_debug_timer = 0.0
	_active = value


func _player_ready(_player:PlayerCharacter) -> void:
	Signals.toggle_display.emit(&"play_ui", true)
	Signals.start_round.emit()
	
