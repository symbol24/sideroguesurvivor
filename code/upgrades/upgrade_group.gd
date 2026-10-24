class_name UpgradeGroup extends Resource


enum Type {DAMAGE, BULLET_COUNT, RELOAD_SPEED, RELOAD_BONUS, SPECIAL_RELOAD}
enum Calculation {ADDITIVE, MULTIPLICATIVE, LOGARITHMIC}


@export var id := &""
@export var type:Type
@export var calculation:Calculation
@export var group:Array[Upgrade]