class_name PlayUi extends RidControl


var _timer_active := false

@onready var reload_delay_bar:ProgressBar = %reload_delay_bar


func _ready() -> void:
	super()
	Signals.start_reload_timer.connect(_start_reload_timer)


func _process(delta: float) -> void:
	if _timer_active:
		if reload_delay_bar.visible:
			reload_delay_bar.value += delta
			if reload_delay_bar.value == reload_delay_bar.max_value:
				_timer_active = false
				reload_delay_bar.set_visible(false)
				Signals.reload_timer_complete.emit()


func _start_reload_timer(timer:float = 1.0) -> void:
	reload_delay_bar.max_value = timer
	reload_delay_bar.value = 0.0
	reload_delay_bar.set_visible(true)
	_timer_active = true
	