class_name SaveData extends Resource


@export var id:int = -1
@export var last_save_time:float
@export var file_name:String = ""

@export var currency_1:int = 0
@export var currency_2:int = 0

# unlocked upgrades is a dict of upgrade_group id and upgrade id
@export var unlocked_upgrades:Dictionary[StringName, int] = {}


func unlock_upgrade(group:UpgradeGroup) -> void:
	if group == null: return
	unlocked_upgrades[group.id] = group.current_id