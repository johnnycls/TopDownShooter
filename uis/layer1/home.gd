extends Control

@onready var new_game_btn: Button = $VBoxContainer/Buttons/NewGameBtn
@onready var continue_btn: Button = $VBoxContainer/Buttons/ContinueBtn

var settings_scene = load("res://uis/layer1/settings.tscn")
var levels_scene = load("res://uis/layer1/levels.tscn")

func _ready() -> void:
	Main.ui_changed.connect(init)

func init():
	if State.progress.get("level", -1)<=0:
		continue_btn.hide()
		if Global.controller != "mouse_keyboard" and Global.controller != "touch_screen":
			new_game_btn.grab_focus()
	else:
		continue_btn.show()
		if Global.controller != "mouse_keyboard" and Global.controller != "touch_screen":
			continue_btn.grab_focus()

func _on_settings_btn_pressed() -> void:
	Main.change_ui(settings_scene.instantiate())

func _on_new_game_btn_pressed() -> void:
	State.save_progress(Config.INIT_PROGRESS)
	Main.start_game(0)

func _on_continue_btn_pressed() -> void:
	Main.change_ui(levels_scene.instantiate())

func _on_quit_btn_pressed() -> void:
	get_tree().quit()
