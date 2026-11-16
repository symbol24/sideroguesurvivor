class_name PlayerData extends Resource


@export var id := &""
@export var last_save_time:float

@export var currency_1:int = 0
@export var currency_2:int = 0

@export var purchased_upgrades:Dictionary[StringName, Upgrade] = {}