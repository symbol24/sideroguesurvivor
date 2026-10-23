class_name Coin  extends Node2D


const WAIT := 0.5
const TIME_TO_UI := 1.0
const TARGET := Vector2(28, 28)


func activate(value:int = 0) -> void:
	await get_tree().create_timer(WAIT).timeout
	var tween := create_tween()
	tween.tween_property(self, "global_position", TARGET, TIME_TO_UI)
	await tween.finished
	Signals.update_resource_1.emit(value)
	queue_free()
	