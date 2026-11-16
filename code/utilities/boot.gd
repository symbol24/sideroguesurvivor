class_name Boot extends Node2D


const UI_UID := "uid://cfj2s41lmelbl"
const UPGRADES := "uid://27lxru0tu0xs"
const TARGET := "uid://cclhyovffrc35"


func _ready() -> void:
	var game := Game.new()
	get_tree().root.add_child.call_deferred(game)
	if not game.is_node_ready(): await game.ready
	var data := DataManager.new()
	get_tree().root.add_child.call_deferred(data)
	if not data.is_node_ready(): await data.ready
	var upgrades:UpgradeManager = load(UPGRADES).instantiate()
	get_tree().root.add_child.call_deferred(upgrades)
	if not upgrades.is_node_ready(): await upgrades.ready
	var ui = load(UI_UID).instantiate()
	get_tree().root.add_child.call_deferred(ui)
	if not ui.is_node_ready(): await ui.ready
	if data.all_save_data.is_empty():
		Signals.create_debug_data.emit()
	else:
		Signals.request_load.emit(data.last_save_id)
	var target = load(TARGET)
	get_tree().change_scene_to_packed(target)