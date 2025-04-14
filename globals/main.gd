extends Node

signal ui_changed

var home_scene = load("res://uis/layer1/home.tscn")
var levels_scene = load("res://uis/layer1/levels.tscn")

var current_level: int = -1

@onready var hud = $Hud

var can_open_menu: bool = false

func _ready() -> void:
	change_ui(home_scene.instantiate())

func clear_ui() -> void:
	hud.clear_ui()

func start_game(level: int) -> void:
	current_level = level
	hud.clear_ui()
	Game.start_game(level)

func back_to_home_screen() -> void:
	Game.end_game()
	current_level = -1
	change_ui(home_scene.instantiate())
	hide_status_bar()
	can_open_menu = false

func back_to_level_selection() -> void:
	Game.end_game()
	current_level = -1
	change_ui(levels_scene.instantiate())
	hide_status_bar()
	can_open_menu = false

func change_ui(page: Control) -> void:
	hud.change_ui(page)
	ui_changed.emit()
	
func show_status_bar() -> void:
	hud.show_status_bar()
	
func hide_status_bar() -> void:
	hud.hide_status_bar()

func update_status(new_status: Dictionary) -> void:
	hud.update_status(new_status)

func popup(page: Control) -> void:
	hud.popup(page)
	
func close_popup() -> void:
	hud.close_popup()

func open_menu() -> void:
	hud.open_menu()
	
func close_menu() -> void:
	hud.close_menu()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("auto_skip"):
		Dialogic.Inputs.auto_skip.enabled = true
	elif event.is_action_released("auto_skip"):
		Dialogic.Inputs.auto_skip.enabled = false

func win() -> void:
	if current_level >= State.progress.get("level", 0):
		State.save_progress({"level": current_level+1})