class_name RidControl extends Control


@export var _id := &""

var _game:Game:
	get:
		if _game == null: _game = get_tree().get_first_node_in_group(&"GameManager") as Game
		return _game


func _ready() -> void:
	name = _id


func toggle_display(display:bool) -> void:
	set_visible(display)