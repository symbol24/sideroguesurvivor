class_name BuyMenu extends RidControl

const RELOAD01: UpgradeGroup = preload("uid://ijh2n2vdv4nn")

@export var upgrade_buttons: Array[BuyButton]

var game: Game = null:
	get:
		if game == null: game = get_tree().get_first_node_in_group(&"GameManager")
		return game

@onready var btn_new_round: Button = %btn_new_round
@onready var resource_1: Label = %resource_1
@onready var upgrade_popup: UpgradePopup = %upgrade_popup

var _popup_tween: Tween


func _ready() -> void:
	super()
	btn_new_round.pressed.connect(_start_next_round)

	# Listen for currency updates to keep the shop header fresh in real-time
	Signals.resource_1_updated.connect(_on_resource_1_updated)

	# Listen for tooltip signals from the buy buttons
	Signals.show_upgrade_tooltip.connect(_on_show_upgrade_tooltip)
	Signals.hide_upgrade_tooltip.connect(_on_hide_upgrade_tooltip)

	if upgrade_popup:
		upgrade_popup.hide()


func toggle_display(display := false) -> void:
	if display:
		resource_1.text = str(game.save_data.currency_1)
		_display_upgrades()
	else:
		_on_hide_upgrade_tooltip()
	set_visible(display)


func _start_next_round() -> void:
	Signals.toggle_display.emit(&"buy_menu", false)
	Signals.toggle_display.emit(&"play_ui", true)
	Signals.start_round.emit()


func _display_upgrades() -> void:
	for each in upgrade_buttons:
		if each != null:
			each.set_state()


func _on_resource_1_updated(new_value: int) -> void:
	if visible:
		resource_1.text = str(new_value)


func _on_show_upgrade_tooltip(upgrade_group: UpgradeGroup, button_pos: Vector2, button_size: Vector2) -> void:
	if not upgrade_popup:
		return

	upgrade_popup.set_text(upgrade_group)
	upgrade_popup.show()

	# Force size update so calculations use correct dimensions
	upgrade_popup.reset_size()

	# Center the pivot so it scales outward from its middle
	upgrade_popup.pivot_offset = upgrade_popup.size / 2

	# Get viewport size to check boundaries
	var viewport_size = get_viewport_rect().size
	var popup_size = upgrade_popup.size

	# Default target position (to the right of the button)
	var target_pos = button_pos + Vector2(button_size.x + 10, 0)

	# Screen Clamping Logic
	if target_pos.x + popup_size.x > viewport_size.x:
		target_pos.x = button_pos.x - popup_size.x - 10

	if target_pos.y + popup_size.y > viewport_size.y:
		target_pos.y = viewport_size.y - popup_size.y - 10

	upgrade_popup.global_position = target_pos

	# Pop-in scale animation
	if _popup_tween and _popup_tween.is_valid():
		_popup_tween.kill()

	upgrade_popup.scale = Vector2(0.05, 0.05)
	_popup_tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	_popup_tween.tween_property(upgrade_popup, "scale", Vector2.ONE, 0.2)


func _on_hide_upgrade_tooltip() -> void:
	if upgrade_popup:
		if _popup_tween and _popup_tween.is_valid():
			_popup_tween.kill()
		upgrade_popup.hide()
