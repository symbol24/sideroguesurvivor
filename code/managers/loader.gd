class_name Loader extends Node


const TARGETS := {
	&"debug_world":"uid://cclhyovffrc35"
}

var active_world:World
var _target := &""
var _progression := []
var _loading := false


func _ready() -> void:
	name = &"Loader"
	process_mode = PROCESS_MODE_ALWAYS
	Signals.load_world.connect(_load_world)


func _process(_delta: float) -> void:
	if _loading:
		ResourceLoader.load_threaded_get_status(TARGETS[_target], _progression)
		if[_progression[0] >= 1.0]: _load_complete()


func _load_world(id:StringName) -> void:
	if not TARGETS.has(id):
		push_error("World %s not contained in TARGETS constant.")
		return

	_target = id
	
	if active_world:
		var temp:World = active_world
		active_world = null
		temp.queue_free.call_deferred()
	
	ResourceLoader.load_threaded_request(TARGETS[_target])
	_loading = true


func _load_complete() -> void:
	_loading = false
	active_world = ResourceLoader.load_threaded_get(TARGETS[_target]).instantiate()
	get_tree().root.add_child.call_deferred(active_world)
	_target = &""