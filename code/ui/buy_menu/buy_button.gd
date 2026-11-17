class_name BuyButton extends Control


@export var upgrade_data: UpgradeGroup

@onready var icon: TextureRect = %icon
@onready var resource_1: Label = %resource_1
@onready var count: Label = %count
@onready var mouse_layer: Control = %mouse_layer

var is_disabled := false
var is_hovering := false
var _tween: Tween


func _ready() -> void:
	assert(upgrade_data != null, name + " does not contain an upgrade group!")
	Signals.upgrade_purchased.connect(_on_upgrade_purchased)

	# Connect the mouse layer's signals
	mouse_layer.mouse_entered.connect(_on_mouse_enter)
	mouse_layer.mouse_exited.connect(_on_mouse_exit)
	mouse_layer.gui_input.connect(_on_mouse_layer_gui_input)

	# Center the pivot offset so the button scales from its middle
	pivot_offset = size / 2

	set_state()


func set_state() -> void:
	if upgrade_data.icon_uid != "":
		icon.texture = load(upgrade_data.icon_uid)

	if upgrade_data.is_maxed:
		count.text = "MAX"
		resource_1.text = "-"
		is_disabled = true
		return

	count.text = str(upgrade_data.current_id) + "/" + str(upgrade_data.group.size())
	resource_1.text = str(upgrade_data.get_current_cost(Game.Currency.CURRENCY1))


func _on_mouse_layer_gui_input(event: InputEvent) -> void:
	if is_disabled or upgrade_data.is_maxed:
		return

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		Signals.attempt_purchase.emit(upgrade_data)


func _on_upgrade_purchased(group: UpgradeGroup) -> void:
	if group == upgrade_data:
		set_state()


func _on_mouse_enter() -> void:
	is_hovering = true

	# Kill any active tween so rapid enter/exit doesn't stutter
	if _tween and _tween.is_valid():
		_tween.kill()

	_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	_tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.2)
	
	Signals.show_upgrade_tooltip.emit(upgrade_data, global_position, Vector2(24, 25))


func _on_mouse_exit() -> void:
	is_hovering = false

	if _tween and _tween.is_valid():
		_tween.kill()

	_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	_tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2)

	Signals.hide_upgrade_tooltip.emit()