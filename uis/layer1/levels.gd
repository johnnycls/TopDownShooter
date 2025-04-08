extends Control

var home_scene = load("res://uis/layer1/home.tscn")

func _on_back_btn_pressed() -> void:
    Main.change_ui(home_scene.instantiate())