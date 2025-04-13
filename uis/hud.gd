extends Node

var select_sound = preload("res://assets/sound_effects/select.mp3")
var click_sound = preload("res://assets/sound_effects/shoot.mp3")

@onready var ui: CanvasLayer = $UILayer
@onready var status_bar: CanvasLayer = $StatusBar
@onready var popup_layer: CanvasLayer = $PopupLayer
@onready var menu: CanvasLayer = $Menu
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

func select() -> void:
	Global.play_sound(select_sound, audio_player)

func click() -> void:
	Global.play_sound(click_sound, audio_player)

func _ready() -> void:
	add_sound_effects_for_btns(ui)
	add_sound_effects_for_btns(menu)
	State.progress_updated.connect(update_status)
	
func add_sound_effects_for_btns(node: Node) -> void:
	if node is Button or node is TextureButton:
		if Global.controller == "mouse_keyboard":
			if not node.mouse_entered.is_connected(select):
				node.mouse_entered.connect(select)
		else:
			if not node.focus_entered.is_connected(select):
				node.focus_entered.connect(select)
				
		if not node.button_down.is_connected(select):
			node.button_down.connect(click)

	for child in node.get_children():
		add_sound_effects_for_btns(child)
		
func clear_ui() -> void:
	for n in ui.get_children():
		n.queue_free()

func change_ui(page: Control) -> void:
	clear_ui()
	ui.add_child(page)
	add_sound_effects_for_btns(page)
	
func show_status_bar() -> void:
	status_bar.open()
	update_status()
	
func hide_status_bar() -> void:
	status_bar.close()

func popup(page: Control) -> void:
	popup_layer.popup(page)
	
func close_popup() -> void:
	popup_layer.close_popup()

func open_menu() -> void:
	menu.open_menu()
	
func close_menu() -> void:
	menu.close_menu()
	
func update_status() -> void:
	status_bar.update_status()
	add_sound_effects_for_btns(status_bar)
