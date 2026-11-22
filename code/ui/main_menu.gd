class_name MainMenu extends RidControl


@onready var btn_play:Button = %btn_play


func _ready() -> void:
	super()
	btn_play.pressed.connect(_on_btn_play_pressed)
	Signals.wipe_half_mark.connect(_on_wipe_half_way_mark)


func _on_btn_play_pressed() -> void:
	Signals.toggle_display.emit(&"wipe_overlay")
	Signals.load_world.emit(&"debug_world")


func _on_wipe_half_way_mark() -> void:
	toggle_display(false)