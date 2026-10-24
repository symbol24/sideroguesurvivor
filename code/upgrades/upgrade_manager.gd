class_name UpgradeManager extends Node


@export var upgrade_groups:Array[UpgradeGroup]


func _ready() -> void:
	name = &"UpgadeManager"
	process_mode = PROCESS_MODE_ALWAYS