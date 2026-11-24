class_name AudioManager extends Node


const AUDIOPLAYLIST:AudioPlaylist = preload("uid://cxet0eq37a5ms")


enum Channel {MUSIC, SFX}


var active_players:Dictionary[StringName, RidAudioStreamPlayer] = {}
var active_music:AudioStreamPlayer


func _ready() -> void:
	name = &"AudioManager"
	process_mode = PROCESS_MODE_ALWAYS
	Signals.play_audio.connect(_play_audio)
	
	_ensure_bus(&"Music")
	_ensure_bus(&"SFX")

	AUDIOPLAYLIST.create_list()


func _play_audio(id:StringName) -> void:
	var audio:AudioData = AUDIOPLAYLIST.get_audio(id)
	if audio == null: return
	
	if audio.is_unique and active_players.has(id) and active_players[id].playing:
		return

	var player:RidAudioStreamPlayer = RidAudioStreamPlayer.new()
	add_child.call_deferred(player)
	if not player.is_node_ready(): await player.ready
	player.id = id
	player.set_stream(audio.file)
	player.set_volume_db(audio.decibel_offset)
	player.set_bus(&"Music" if audio.channel == Channel.MUSIC else &"SFX")
	player.set_process_mode(PROCESS_MODE_ALWAYS if audio.channel == Channel.MUSIC else PROCESS_MODE_PAUSABLE)
	if audio.is_unique: active_players[id] = player
	if audio.randomize_pitch: player.set_pitch_scale(randf_range(audio.pitch_range.x, audio.pitch_range.y))
	player.rid_finished.connect(_finished_audio)
	
	match audio.channel:
		Channel.MUSIC:
			_play_music(player)
		_:
			_play_sfx(player)


func _play_sfx(player:AudioStreamPlayer) -> void:
	if player: player.play()
	

func _play_music(player:AudioStreamPlayer) -> void:
	if not player: return
	if active_music and active_music.playing:
		#TODO: Play a nice fade between songs
		var temp:= active_music
		active_music = player
		temp.stop()
		_finished_audio(temp.id)
		active_music.play()
		return
	active_music = player
	active_music.play()
			


func _ensure_bus(bus_name: StringName) -> void:
	if AudioServer.get_bus_index(bus_name) != -1:
		return

	AudioServer.add_bus()
	var bus_index := AudioServer.get_bus_count() - 1
	AudioServer.set_bus_name(bus_index, bus_name)
	AudioServer.set_bus_send(bus_index, &"Master")


func _finished_audio(id:StringName) -> void:
	if active_players.has(id):
		var temp := active_players[id]
		temp.queue_free.call_deferred()
		