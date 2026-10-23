class_name Game extends Node2D


var _run_resource1 := 0


func _ready() -> void:
	add_to_group(&"GameManager")
	name = &"GameManager"
	Signals.update_resource_1.connect(_update_resource_1)


func _update_resource_1(value:int) -> void:
	_run_resource1 += value
	Signals.resource_1_updated.emit(_run_resource1)