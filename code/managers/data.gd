class_name DataManager extends Node


const FOLDER = "user://save/"
const EXTENSION = "tres"


var loaded_save_file: SaveData
var all_save_data: Array[SaveData] = []
var last_save_id:int:
	get:
		if _get_last_saved_save() != null: return _get_last_saved_save().id
		return -1


func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	name = &"DataManager"
	all_save_data = _get_all_saves()
	Signals.request_load.connect(load_file)
	Signals.request_save.connect(save)
	Signals.upgrade_purchased.connect(_on_upgrade_purchased)


func save(save_data: SaveData = null) -> void:
	_check_folder()

	if save_data != null:
		loaded_save_file = save_data
	elif loaded_save_file == null:
		loaded_save_file = SaveData.new()

	if not all_save_data.has(loaded_save_file):
		loaded_save_file.id = _get_next_id()
		loaded_save_file.file_name = str(hash(loaded_save_file.id))
		all_save_data.append(loaded_save_file)

	loaded_save_file.last_save_time = Time.get_unix_time_from_system()
	ResourceSaver.save(loaded_save_file, FOLDER + loaded_save_file.file_name + "." + EXTENSION)
	Signals.save_complete.emit()


func load_file(id: int) -> void:
	loaded_save_file = _get_save_from_id(id)
	Signals.load_complete.emit(loaded_save_file)


func _get_all_saves() -> Array[SaveData]:
	var saves: Array[SaveData] = []
	var dir: DirAccess = _check_folder()
	if dir != null:
		for file in dir.get_files():
			if file.get_extension() == EXTENSION:
				var res := load(FOLDER + file) as SaveData
				if res != null:
					saves.append(res)
	return saves


func _check_folder() -> DirAccess:
	if not DirAccess.dir_exists_absolute(FOLDER):
		var result := DirAccess.make_dir_recursive_absolute(FOLDER)
		if result != OK:
			print_debug("Error creating save folder: ", result)
			return null
	return DirAccess.open(FOLDER)


func _get_next_id() -> int:
	var max_id := -1
	for each in all_save_data:
		if each.id > max_id:
			max_id = each.id
	return max_id + 1


func _get_save_from_id(id: int) -> SaveData:
	for each in all_save_data:
		if each.id == id:
			return each
	return null


func _get_last_saved_save() -> SaveData:
	var last: SaveData = null
	for each in all_save_data:
		if last == null or each.last_save_time > last.last_save_time:
			last = each
	return last


func _on_upgrade_purchased(group: UpgradeGroup) -> void:
	if loaded_save_file != null:
		loaded_save_file.unlock_upgrade(group)