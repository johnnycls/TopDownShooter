extends Control

const home := preload("res://uis/layer1/home.tscn")
var click_sound = preload("res://assets/sound_effects/shoot.mp3")

@onready var back_btn: Button = $BackBtn
@onready var lang_select: OptionButton = $LangSelect

func _ready() -> void:
	Main.ui_changed.connect(init)
	
	for lang_id in Config.LANG_IDS_TO_CODES:
		lang_select.add_item(Config.LANG_NAMES[Config.LANG_IDS_TO_CODES[lang_id]], lang_id)
	lang_select.selected = State.settings.get("language", Config.DEFAULT_LANG)

func init() -> void:
	if Global.controller != "mouse_keyboard" and Global.controller != "touch_screen":
		lang_select.grab_focus()
	
func _save_settings() -> void:
	var settings: Dictionary = {
		"language": lang_select.selected
	}
	State.save_settings(settings)

func _on_back_btn_pressed() -> void:
	_save_settings()
	Main.change_ui(home.instantiate())

func _on_lang_select_item_selected(id: int) -> void:
	var code: String = Config.LANG_IDS_TO_CODES[id]
	TranslationServer.set_locale(code)
	Global.play_sound(click_sound)
