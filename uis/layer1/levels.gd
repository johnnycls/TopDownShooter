extends Control

@onready var btn_container: Control = $MarginContainer/VBoxContainer/GridContainer

var home_scene = load("res://uis/layer1/home.tscn")
var lv_btn_scene = preload("res://uis/layer1/lv_btn.tscn")

func _ready() -> void:
    for i in range(State.progress.get("level", 0)+1):
        var btn: Button = lv_btn_scene.instantiate()
        btn.text = str(i + 1)
        btn.pressed.connect(func(): _on_lv_btn_pressed(i))
        btn_container.add_child(btn)
    
func _on_lv_btn_pressed(level: int) -> void:
    Main.start_game(level)

func _on_back_btn_pressed() -> void:
    Main.change_ui(home_scene.instantiate())