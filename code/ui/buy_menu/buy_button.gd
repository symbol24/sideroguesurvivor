class_name BuyButton extends Control


const LOCKED := "uid://ciswaf3fva3bw"


@export var upgrade_data: UpgradeGroup

@onready var icon: TextureRect = %icon
@onready var resources:GridContainer = %resources
@onready var coin_icon_1:TextureRect = %coin_1
@onready var resource_1: Label = %resource_1
@onready var coin_icon_2:TextureRect = %coin_2
@onready var resource_2: Label = %resource_2
@onready var count: Label = %count
@onready var mouse_layer: Control = %mouse_layer
@onready var maxed_check_mark: TextureRect = %maxed_check_mark

var is_locked := true
var is_disabled := false
var is_hovering := false
var _tween: Tween
var _updating_state := false


func _ready() -> void:
	assert(upgrade_data != null, name + " does not contain an upgrade group!")
	Signals.upgrade_purchased.connect(_on_upgrade_purchased)
	Signals.unlock_upgrade_group_in_ui.connect(_on_upgrade_unlocked)

	# Connect the mouse layer's signals
	mouse_layer.mouse_entered.connect(_on_mouse_enter)
	mouse_layer.mouse_exited.connect(_on_mouse_exit)
	mouse_layer.gui_input.connect(_on_mouse_layer_gui_input)

	# Center the pivot offset so the button scales from its middle
	pivot_offset = size / 2

	set_state()


func set_state() -> void:
	if _updating_state:
		return
	_updating_state = true
	
	is_locked = upgrade_data.check_requirements()
	maxed_check_mark.set_visible(false)

	if is_locked:
		icon.texture = load(LOCKED) as Texture
		count.text = "LOCKED"
		resources.set_visible(false)
		is_disabled = true
		_updating_state = false
		return

	if upgrade_data.icon_uid != "":
		icon.texture = load(upgrade_data.icon_uid)

	if upgrade_data.is_maxed:
		maxed_check_mark.set_visible(true)
		count.text = "MAX"
		resources.set_visible(false)
		is_disabled = true
		_updating_state = false
		return

	resources.set_visible(true)
	count.text = str(upgrade_data.current_id) + "/" + str(upgrade_data.group.size())
	_toggle_currencies(upgrade_data.current_upgrade)
	is_disabled = false
	_updating_state = false


func _on_mouse_layer_gui_input(event: InputEvent) -> void:
	if is_locked or is_disabled or upgrade_data.is_maxed:
		return

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		Signals.attempt_purchase.emit(upgrade_data)


func _on_upgrade_purchased(group: UpgradeGroup) -> void:
	if group == upgrade_data:
		set_state()


func _on_upgrade_unlocked(group: UpgradeGroup) -> void:
	if group == upgrade_data:
		set_state()


func _on_mouse_enter() -> void:
	is_hovering = true

	# Kill any active tween so rapid enter/exit doesn't stutter
	if _tween and _tween.is_valid():
		_tween.kill()

	_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	_tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.2)

	if not is_locked and not is_disabled:
		Signals.show_upgrade_tooltip.emit(upgrade_data, global_position, Vector2(24, 25))


func _on_mouse_exit() -> void:
	is_hovering = false

	if _tween and _tween.is_valid():
		_tween.kill()

	_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	_tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2)

	Signals.hide_upgrade_tooltip.emit()


func _toggle_currencies(upgrade: Upgrade) -> void:
	var has:Array[StringName] = []
	for cost:CurrencyCost in upgrade.cost:
		match cost.currency:
			Game.Currency.CURRENCY1:
				coin_icon_1.set_visible(true)
				resource_1.set_visible(true)
				resource_1.text = str(upgrade_data.get_current_cost(Game.Currency.CURRENCY1))
				has.append(&"CURRENCY1")
			Game.Currency.CURRENCY2:
				coin_icon_2.set_visible(true)
				resource_2.set_visible(true)
				resource_2.text = str(upgrade_data.get_current_cost(Game.Currency.CURRENCY2))
				has.append(&"CURRENCY2")
			_:
				pass
	
	for currency in Game.Currency:
		if has.has(currency): continue
		match currency:
			&"CURRENCY1":
				coin_icon_1.set_visible(false)
				resource_1.set_visible(false)
				resource_1.text = "0"
			&"CURRENCY2":
				coin_icon_2.set_visible(false)
				resource_2.set_visible(false)
				resource_2.text = "0"
			_:
				pass
