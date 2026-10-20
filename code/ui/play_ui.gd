class_name PlayUi extends RidControl


@export var bullet_icons:Array[BulletIcon] = []

var _timer_active := false

@onready var reload_delay_bar:ProgressBar = %reload_delay_bar


func _ready() -> void:
	super()
	Signals.start_reload_timer.connect(_start_reload_timer)
	Signals.shots_fired.connect(_shots_fired)


func _process(delta: float) -> void:
	if _timer_active:
		if reload_delay_bar.visible:
			reload_delay_bar.value += delta
			if reload_delay_bar.value == reload_delay_bar.max_value:
				_timer_active = false
				reload_delay_bar.set_visible(false)
				_reset_ammo()
				Signals.reload_timer_complete.emit()


func _start_reload_timer(timer:float = 1.0) -> void:
	reload_delay_bar.max_value = timer
	reload_delay_bar.value = 0.0
	reload_delay_bar.set_visible(true)
	_timer_active = true


func _shots_fired(remaining:int) -> void:
	for i in bullet_icons.size():
		print("remaining: ", remaining, " i: ", i+1)
		bullet_icons[i].toggle(true if i+1 <= remaining else false)
		

func _reset_ammo() -> void:
	for icon in bullet_icons:
		icon.toggle(true)
