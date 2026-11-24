class_name AudioPlaylist extends Resource


@export var audio_data:Array[AudioData] = []

var list:Dictionary[StringName, AudioData] = {}


func get_audio(id:StringName) -> AudioData:
	if not list.has(id):
		push_warning("Audio Playlist does not contain an audio data for id %s." % id)
		return null
	
	return list[id]


func create_list() -> void:
	if audio_data.is_empty(): return
	
	var count := 0
	var warnings := false
	
	for data:AudioData in audio_data:
		if data == null:
			push_warning("Audio playlist contains a null entry.")
			warnings = true
			count += 1
			continue
		var key := data.resource_path.get_file().get_basename()
		if data.file == null:
			push_warning("Audio data %s missing audio stream file, skipped." % key)
			warnings = true
			count += 1
			continue
		if list.has(key):
			push_warning("Duplicate audio data name %s found when creating audio list." % key)
			warnings = true
			count += 1
			continue
		list[key] = data
	
	if warnings:
		push_warning("Audio list created with %s warnings." % count)
	else:
		print("Audio list created without warnings.")