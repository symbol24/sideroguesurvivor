class_name UpgradeGroup extends Resource


enum Type {DAMAGE, BULLET_COUNT, RELOAD_SPEED, RELOAD_BONUS, SPECIAL_RELOAD}
enum Calculation {ADDITIVE, MULTIPLICATIVE, LOGARITHMIC}


@export var id := &""
@export var icon_uid := ""
@export var display_name:String
@export var description:String
@export var type:Type
@export var calculation:Calculation
@export var group:Array[Upgrade]

var current_id := 0
var current_cost:Dictionary[Game.Currency, int]:
	get:
		return group[current_id].cost