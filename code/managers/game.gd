class_name Game extends Node2D


const PLAYER_POS := Vector2(288, 241)
const DEBUG_PLAYER := preload("uid://s6kbt5sqli2s")


enum Currency {CURRENCY1, CURRENCY2}
enum State {MENUS, PLAYING, BUYING, DEAD}
enum Result {NONE, FAILURE, SUCCESS}


var player:PlayerCharacter
var save_data: SaveData
var _state:State = State.MENUS
var _next_state:State = State.MENUS
var _last_round_result := Result.SUCCESS
var _round_number := 0:
	set(value):
		_round_number = value
		Signals.round_number_updated.emit(_round_number)
var _round_timer := 10:
	set(value):
		_round_timer = maxi(value, 0)
		Signals.round_timer_updated.emit(_round_timer)
		if _round_timer <= 0 and _state == State.PLAYING:
			_last_round_result = Result.SUCCESS
			_end_round()
var _timer := 1.0:
	set(value):
		_timer = value
		if _timer <= 0.0:
			_round_timer -= 1
			_timer = 1.0
var _world_ready := false


func _ready() -> void:
	add_to_group(&"GameManager")
	name = &"GameManager"
	process_mode = PROCESS_MODE_ALWAYS
	Signals.start_round.connect(_start_round)
	Signals.player_ready.connect(_player_ready)
	Signals.create_debug_data.connect(_create_debug_data)
	Signals.update_resource_1.connect(_update_resource_1)
	Signals.load_complete.connect(_load_complete)
	Signals.wipe_finished.connect(_on_wipe_finished)
	Signals.wipe_half_mark.connect(_on_wipe_half_mark)
	Signals.set_next_state.connect(_set_next_state)
	Signals.world_ready.connect(_toggle_world_ready)
	Signals.player_dead.connect(_player_dead)


func _process(delta: float) -> void:
	if _state == State.PLAYING and _round_timer > 0: _timer -= delta


func _set_next_state(new_state:State) -> void:
	_next_state = new_state


func _start_round() -> void:
	if _last_round_result == Result.SUCCESS:
		# only go to next round on success
		_round_number += 1
	_round_timer = 15
	_timer = 1.0
	

func _end_round() -> void:
	# Freeze everything in place (except griblies)
	Signals.toggle_active.emit(false)
	_next_state = State.BUYING
	# Trigger the wipe in transition
	await get_tree().create_timer(0.3).timeout
	Signals.toggle_display.emit(&"wipe_overlay", true)


func _on_wipe_half_mark() -> void:
	match _next_state:
		State.PLAYING:
			if _world_ready:
				Signals.spawn_character.emit(DEBUG_PLAYER, Game.PLAYER_POS)
				Signals.toggle_display.emit(&"buy_menu", false)
				Signals.toggle_display.emit(&"play_ui", true)
		State.BUYING:
			if is_instance_valid(player):
				player.queue_free()
				player = null
				Signals.round_end_cleanup.emit()
				Signals.toggle_display.emit(&"buy_menu", true)
		_:
			pass
		

func _on_wipe_finished() -> void:
	_state = _next_state
	match _state:
		State.PLAYING:
			_start_round()
		State.BUYING:
			pass
		_:
			pass
			

func _player_ready(_player:PlayerCharacter) -> void:
	assert(_player != null, "Player received by Game Manager is null.")
	player = _player
	Signals.toggle_active.emit(true)
	Signals.toggle_display.emit(&"play_ui", true)


func _create_debug_data() -> void:
	save_data = SaveData.new()


func _update_resource_1(value:int) -> void:
	assert(save_data != null, "Save Data is null in Game Manager.")
	save_data.currency_1 += value
	Signals.resource_1_updated.emit(save_data.currency_1)


func _load_complete(data:SaveData) -> void:
	assert(data != null, "Data received is null in Game Manager.")
	save_data = data
	Signals.resource_1_updated.emit(save_data.currency_1)


func _toggle_world_ready(value:bool) -> void:
	_world_ready = value


func _player_dead() -> void:
	_state = State.DEAD
	_next_state = State.BUYING
	_end_round()