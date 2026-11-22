class_name WipeTransition extends ColorRect


enum Direction {LEFT, RIGHT, UP, DOWN}
enum Mode {IN, OUT}


const DURATION_IN := 1.0
const DURATION_OUT := 0.5


var _direction: Direction


func _ready() -> void:
	z_index = 1000
	visible = false


func _get_offscreen_position() -> Vector2:
	match _direction:
		Direction.LEFT:
			return Vector2(-576, 0)
		Direction.RIGHT:
			return Vector2(576, 0)
		Direction.UP:
			return Vector2(0, -324)
		Direction.DOWN:
			return Vector2(0, 324)
	return Vector2(-576, 0)


func start() -> void:
	_direction = Direction.values()[randi() % 4]
	
	visible = true
	position = _get_offscreen_position()
	size = Vector2(576, 324)
	
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position", Vector2(0, 0), DURATION_IN)
	await tween.finished

	Signals.wipe_half_mark.emit()
	
	position = Vector2(0, 0)
	
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position", _get_offscreen_position(), DURATION_OUT)
	await tween.finished
	visible = false
	Signals.wipe_finished.emit()
