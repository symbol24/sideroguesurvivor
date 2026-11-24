class_name RidAudioStreamPlayer extends AudioStreamPlayer


var id:StringName = &""


signal rid_finished(id:StringName)


func _ready() -> void:
	finished.connect(_finished)	


func _finished() -> void:
	rid_finished.emit(id)