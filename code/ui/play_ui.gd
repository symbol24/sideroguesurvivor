class_name PlayUi extends RidControl


@export var bullet_icons:Array[BulletIcon] = []

var _timer_active := false

@onready var reload_delay_bar:ProgressBar = %reload_delay_bar
@onready var resource_1:Label = %resource_1
@onready var timer_label:Label = %timer_label
@onready var round_number:Label = %round_number


func _ready() -> void:
	super()
	Signals.start_reload_timer.connect(_start_reload_timer)
	Signals.shots_fired.connect(_shots_fired)
	Signals.resource_1_updated.connect(_update_resource_1)
	Signals.round_timer_updated.connect(_update_timer_label)
	Signals.round_number_updated.connect(_update_round_number)


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
		bullet_icons[i].toggle(true if i+1 <= remaining else false)
		

func _reset_ammo() -> void:
	for icon in bullet_icons:
		icon.toggle(true)


func _update_resource_1(value:int) -> void:
	resource_1.text = str(value)


func _update_timer_label(value:int) -> void:
	timer_label.text = str(value)


func _update_round_number(value:int) -> void:
	if round_number == null: return
	round_number.text = str(value)
