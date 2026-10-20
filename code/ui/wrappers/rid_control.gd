class_name RidControl extends Control


@export var _id := &""


func _ready() -> void:
	name = _id


func toggle_display(display := false) -> void:
	set_visible(display)