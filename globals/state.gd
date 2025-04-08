extends Node

signal progress_updated

var progress: Dictionary = Config.INIT_PROGRESS
var settings: Dictionary = {}
var record: Dictionary = {}

func _ready() -> void:
	settings = _read_json_file(Config.SETTINGS_PATH)
	progress = _read_json_file(Config.PROGRESS_PATH)
	record = _read_json_file(Config.RECORD_PATH)
	_update_lang()

func _read_json_file(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		return {}
	var json = JSON.new()
	return json.get_data() if json.parse(file.get_as_text()) == OK else {}
	
func _save_json_file(path: String, data: Dictionary) -> bool:
	var file = FileAccess.open(path, FileAccess.WRITE)
	if not file:
		return false
	file.store_string(JSON.stringify(data))
	file.close()
	return true

func delete_file(path: String) -> void:
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)

func merge_progress(_progress: Dictionary) -> void:
	var new_progress = _progress.merged(progress)
	save_progress(new_progress)

func save_progress(_progress: Dictionary) -> void:
	_save_json_file(Config.PROGRESS_PATH, _progress)
	progress = _progress
	progress_updated.emit()
	
func save_settings(_settings) -> void:
	_save_json_file(Config.SETTINGS_PATH, _settings)
	settings = _settings
	_update_lang()
	
func _update_lang():
	var lang_id: int = settings.get("language", Config.DEFAULT_LANG)
	TranslationServer.set_locale(Config.LANG_IDS_TO_CODES[lang_id])

func merge_record(_record: Dictionary) -> void:
	record = _record.merged(record)
	save_record(record)

func save_record(_record: Dictionary) -> bool:
	return _save_json_file(Config.RECORD_PATH, _record)
