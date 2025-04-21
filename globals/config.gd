extends Node

const PROGRESS_PATH = "user://progress.save"
const RECORD_PATH = "user://record.save"
const SETTINGS_PATH = "user://settings.save"

const LANG_IDS_TO_CODES: Dictionary = {0: "cmn", 1: "en", 2: "zh", 3: "ja", 4: "ko", 5: "es", 6: "ru"}
const LANG_NAMES: Dictionary = {"cmn": "简体中文", "en": "English", "zh": "繁體中文", "ja": "日本語", "ko": "한문", "es": "Español", "ru": "Русский"}
const DEFAULT_LANG: int = 1

var INIT_PROGRESS: Dictionary = {}

const LEVEL_NUM = 7

# collision layers
# 1: floor
# 2: player collision
# 3: player hit area
# 4: enemy
# 5: bullet