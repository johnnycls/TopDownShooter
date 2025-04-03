extends Control

@onready var back_btn: Button = $CenterContainer/VBoxContainer/BackBtn
	
func _ready() -> void:
	get_tree().paused = true
	if Global.controller != "mouse_keyboard" and Global.controller != "touch_screen":
		back_btn.grab_focus()

func _on_back_btn_pressed() -> void:
	close()
	
func close() -> void:
	get_tree().paused = false
	queue_free()
	
func _on_home_screen_btn_pressed() -> void:
	get_tree().paused = false
	Main.back_to_home_screen()
	queue_free()
