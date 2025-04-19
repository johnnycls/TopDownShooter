extends Control

@onready var story_btn: Button = $VBoxContainer/Buttons/StoryBtn
@onready var extra_btn: Button = $VBoxContainer/Buttons/ExtraBtn

var settings_scene = load("res://uis/layer1/settings.tscn")
var levels_scene = load("res://uis/layer1/levels.tscn")

func _ready() -> void:
	BgmPlayer.play_bgm(0)
	Main.ui_changed.connect(init)

func init():
	if Global.controller != "mouse_keyboard" and Global.controller != "touch_screen":
		story_btn.grab_focus()

func _on_settings_btn_pressed() -> void:
	Main.change_ui(settings_scene.instantiate())

func _on_continue_btn_pressed() -> void:
	Main.change_ui(levels_scene.instantiate())

func _on_quit_btn_pressed() -> void:
	get_tree().quit()

func _on_story_btn_pressed() -> void:
	Main.change_ui(levels_scene.instantiate())

func _on_extra_btn_pressed() -> void:
	Main.change_ui(levels_scene.instantiate())
