class_name PlayUi extends RidControl


const BULLETICON := "uid://c2nsju14umt1m"


var _timer_active := false
var _bullet_scene:PackedScene:
	get:
		if _bullet_scene == null: _bullet_scene = load(BULLETICON)
		return _bullet_scene
var _bullet_icons:Array[BulletIcon] = []

@onready var reload_delay_bar:ProgressBar = %reload_delay_bar
@onready var resource_1:Label = %resource_1
@onready var timer_label:Label = %timer_label
@onready var round_number:Label = %round_number
@onready var bullet_icons_grid:GridContainer = %bullets


func _ready() -> void:
	super()
	Signals.start_reload_timer.connect(_start_reload_timer)
	Signals.shots_fired.connect(_shots_fired)
	Signals.resource_1_updated.connect(_update_resource_1)
	Signals.round_timer_updated.connect(_update_timer_label)
	Signals.round_number_updated.connect(_update_round_number)
	Signals.player_ready.connect(_on_player_ready)


func _on_player_ready(_player:PlayerCharacter) -> void:
	_update_bullets()


func _process(delta: float) -> void:
	if _timer_active:
		if reload_delay_bar.visible:
			reload_delay_bar.value += delta
			if reload_delay_bar.value >= reload_delay_bar.max_value:
				_timer_active = false
				reload_delay_bar.set_visible(false)
				_reset_ammo()
				Signals.reload_timer_complete.emit()


func toggle_display(display:bool) -> void:
	set_visible(display)
	if display:
		_update_resource_1(_game.save_data.currency_1)
		_update_timer_label(0)
		_update_bullets()
		

func _start_reload_timer(timer:float = 1.0) -> void:
	reload_delay_bar.max_value = timer
	reload_delay_bar.value = 0.0
	reload_delay_bar.set_visible(true)
	_timer_active = true


func _shots_fired(remaining:int) -> void:
	for i in _bullet_icons.size():
		_bullet_icons[i].toggle(true if i < remaining else false)
		

func _reset_ammo() -> void:
	for icon in _bullet_icons:
		icon.toggle(true)


func _update_resource_1(value:int) -> void:
	resource_1.text = str(value)


func _update_timer_label(value:int) -> void:
	timer_label.text = str(value)


func _update_round_number(value:int) -> void:
	if round_number == null: return
	round_number.text = str(value)


func _update_bullets() -> void:
	if _game.player != null and _game.player.data != null:
		var bullet_count := _game.player.data.get_bullet_count()
		# Clear existing icons and recreate them fresh
		for icon in _bullet_icons:
			icon.queue_free()
		_bullet_icons.clear()
		for i in bullet_count:
			var icon:BulletIcon = _bullet_scene.instantiate()
			bullet_icons_grid.add_child(icon)
			if not icon.is_node_ready(): await icon.ready
			_bullet_icons.append(icon)
			icon.toggle(true)
