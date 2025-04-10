class_name Level extends Node3D

@onready var player: Node3D = $Player

func _ready() -> void:
    Dialogic.timeline_started.connect(_on_timeline_started)
    Dialogic.timeline_ended.connect(_on_timeline_ended)
    ready()

func ready() -> void:
    pass

func _on_timeline_started() -> void:
    player.can_move = false
    Main.can_open_menu = false

func _on_timeline_ended() -> void:
    player.can_move = true
    Main.can_open_menu = true
