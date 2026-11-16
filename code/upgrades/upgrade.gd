class_name Upgrade extends Resource


@export var id := &""
@export var cost:Dictionary[Game.Currency, int]
@export var value:Variant
@export var prerecs:Dictionary[StringName, bool] = {}
