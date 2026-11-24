class_name MainMenu extends RidControl


@onready var btn_play:Button = %btn_play

var _play_pressed := false


func _ready() -> void:
	super()
	btn_play.pressed.connect(_on_btn_play_pressed)
	Signals.wipe_half_mark.connect(_on_wipe_half_way_mark)
	Signals.play_audio.emit(&"test_music")


func _on_btn_play_pressed() -> void:
	if _play_pressed: return
	_play_pressed = false
	Signals.play_audio.emit(&"test_sfx")
	Signals.toggle_display.emit(&"wipe_overlay")
	Signals.load_world.emit(&"debug_world")
	get_tree().create_timer(1.0).timeout.connect(func() -> void: _play_pressed = false)


func _on_wipe_half_way_mark() -> void:
	toggle_display(false)