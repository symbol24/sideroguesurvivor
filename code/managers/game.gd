class_name Game extends Node2D


const PLAYER_POS := Vector2(288, 241)


enum Currency {CURRENCY1, CURRENCY2}
enum State {MENUS, PLAYING, BUYING}


var _state:State = State.MENUS
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


func _process(delta: float) -> void:
	if _state == State.PLAYING: _timer -= delta


func _start_round() -> void:
	_round_timer = 10
	_timer = 1.0
	_state = State.PLAYING
	Signals.toggle_active.emit(true)
	

func _end_round() -> void:
	Signals.toggle_active.emit(false)
	_state = State.BUYING
	Signals.toggle_display.emit(&"buy_menu", true)
	Signals.toggle_display.emit(&"play_ui", false)
	