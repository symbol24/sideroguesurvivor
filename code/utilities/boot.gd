class_name Boot extends Node2D


const UI_UID := "uid://cfj2s41lmelbl"
const TARGET := "uid://cclhyovffrc35"


func _ready() -> void:
	var game := Game.new()
	get_tree().root.add_child.call_deferred(game)
	if not game.is_node_ready(): await game.ready
	var ui = load(UI_UID).instantiate()
	get_tree().root.add_child.call_deferred(ui)
	if not ui.is_node_ready(): await ui.ready
	var target = load(TARGET)
	get_tree().change_scene_to_packed(target)