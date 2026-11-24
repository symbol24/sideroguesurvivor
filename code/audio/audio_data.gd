class_name AudioData extends Resource


@export var file:AudioStream
@export_range(-100, 100, 5) var decibel_offset:float = 0
@export var channel := AudioManager.Channel.MUSIC
## Music is always UNIQUE.
@export var is_unique := false
@export var randomize_pitch := false
## Taken into account only od randomize_pitch is TRUE.
@export_range(0.8, 1.2, 0.01) var pitch_min:float = 0.9
@export_range(0.8, 1.2, 0.01) var pitch_max:float = 1.1

var pitch_range:Vector2:
	get:
		return Vector2(pitch_min, pitch_max)