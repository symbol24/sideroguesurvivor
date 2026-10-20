class_name Ui extends CanvasLayer


const UIS := {
				&"play_ui":"uid://cesc78rlcx0sl",
			}


var _displays:Dictionary = {}


func _ready() -> void:
	Signals.toggle_display.connect(_toggle_display)


func _toggle_display(id:StringName, display:bool) -> void:
	if _displays.has(id): _displays[id].toggle_display(display)
	else:
		if not UIS.has(id):
			push_error("UIS list in UI does not contain %s." % id)
			return
		var new:RidControl = load(UIS[id]).instantiate()
		add_child(new)
		if not new.is_node_ready(): await new.ready
		new.toggle_display(display)