class_name BuyMenu extends RidControl

const RELOAD01:UpgradeGroup = preload("uid://ijh2n2vdv4nn")


@export var upgrade_buttons:Array[BuyButton]

var game:Game = null:
	get:
		if game == null: game = get_tree().get_first_node_in_group(&"GameManager")
		return game

@onready var btn_new_round:Button = %btn_new_round
@onready var resource_1:Label = %resource_1


func _ready() -> void:
	super()
	btn_new_round.pressed.connect(_start_next_round)


func toggle_display(display := false) -> void:
	if display:
		resource_1.text = str(game.save_data.currency_1)
		_display_upgrades()
		Signals.attempt_purchase.emit(RELOAD01)
	set_visible(display)


func _start_next_round() -> void:
	Signals.toggle_display.emit(&"buy_menu", false)
	Signals.toggle_display.emit(&"play_ui", true)
	Signals.start_round.emit()


func _display_upgrades() -> void:
	for each in upgrade_buttons:
		each.set_state()
