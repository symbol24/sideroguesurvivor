class_name Upgrade extends Resource


@export var id := &""
@export var cost:Array[CurrencyCost] = []
@export var value:Variant
@export var prerecs:Dictionary[StringName, bool] = {}


func get_cost(currency_type: Game.Currency) -> int:
	for each in cost:
		if each.currency == currency_type:
			return each.amount
	return 0
