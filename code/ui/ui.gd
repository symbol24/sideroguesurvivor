class_name Ui extends CanvasLayer


const UIS := {
				&"play_ui":"uid://cesc78rlcx0sl",
				&"buy_menu":"uid://52nnvny06moc",
				&"wipe_overlay":"uid://bt3cc8wrefdv1",
				&"main_menu":"uid://bdglxo7mf07j3"
			}


var _displays:Dictionary = {}
var _next_ui:StringName = &""


func _ready() -> void:
	Signals.toggle_display.connect(_toggle_display)
	Signals.set_next_ui.connect(_set_next_ui)


func _toggle_display(id:StringName = _next_ui, display:bool = true) -> void:
	var displayed:RidControl
	if _displays.has(id):
		displayed = _displays[id]
		if displayed is WipeOverlay:
			displayed.toggle_display(display)
		else:
			displayed.toggle_display(display)
	else:
		if not UIS.has(id):
			push_error("UIS list in UI does not contain %s." % id)
			return
		displayed = load(UIS[id]).instantiate()
		add_child(displayed)
		if not displayed.is_node_ready(): await displayed.ready
		_displays[id] = displayed
		if displayed is WipeOverlay:
			displayed.toggle_display(display)
		else:
			displayed.toggle_display(display)

	if display and displayed != null:
		var count:int = get_child_count()
		move_child(displayed, count)


func _set_next_ui(new:StringName) -> void:
	_next_ui = new
