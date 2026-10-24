class_name Game extends Node2D


enum Currency {CURRENCY1, CURRENCY2}

var _player_data:PlayerData = null


func _ready() -> void:
	add_to_group(&"GameManager")
	name = &"GameManager"
	process_mode = PROCESS_MODE_ALWAYS
	Signals.update_resource_1.connect(_update_resource_1)
	
	if _player_data == null: _player_data = PlayerData.new()


func _update_resource_1(value:int) -> void:
	_player_data.currency1 += value
	Signals.resource_1_updated.emit(_player_data.currency1)