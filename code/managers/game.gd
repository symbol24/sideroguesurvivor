class_name Game extends Node2D


const PLAYER_POS := Vector2(288, 241)


enum Currency {CURRENCY1, CURRENCY2}
enum State {MENUS, PLAYING, BUYING}


var player:PlayerCharacter
var player_data:PlayerData
var _state:State = State.MENUS
var _round_number := 0:
	set(value):
		_round_number = value
		Signals.round_number_updated.emit(_round_number)
var _round_timer := 10:
	set(value):
		_round_timer = value
		Signals.round_timer_updated.emit(_round_timer)
		if _round_timer <= 0: _end_round()
var _timer := 1.0:
	set(value):
		_timer = value
		if _timer <= 0.0:
			_round_timer -= 1
			_timer = 1.0


func _ready() -> void:
	add_to_group(&"GameManager")
	name = &"GameManager"
	process_mode = PROCESS_MODE_ALWAYS
	Signals.start_round.connect(_start_round)
	Signals.player_ready.connect(_player_ready)
	Signals.create_debug_data.connect(_create_debug_data)
	Signals.update_resource_1.connect(_update_resource_1)


func _process(delta: float) -> void:
	if _state == State.PLAYING: _timer -= delta


func _start_round() -> void:
	_round_number += 1
	_round_timer = 10
	_timer = 1.0
	_state = State.PLAYING
	Signals.toggle_active.emit(true)
	

func _end_round() -> void:
	Signals.toggle_active.emit(false)
	_state = State.BUYING
	Signals.toggle_display.emit(&"buy_menu", true)
	Signals.toggle_display.emit(&"play_ui", false)


func _player_ready(_player:PlayerCharacter) -> void:
	assert(_player != null, "Player received by Game Manager is null.")
	player = _player


func _create_debug_data() -> void:
	player_data = PlayerData.new()


func _update_resource_1(value:int) -> void:
	player_data.currency_1 += value
	Signals.resource_1_updated.emit(player_data.currency_1)