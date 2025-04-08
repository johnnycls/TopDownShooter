class_name Level extends Node3D

@onready var player: Node3D = $Player

func _ready() -> void:
    Dialogic.timeline_started.connect(_on_timeline_started)
    Dialogic.timeline_ended.connect(_on_timeline_ended)
    init()

func init() -> void:
    pass

func _on_timeline_started() -> void:
    player.can_move = false

func _on_timeline_ended() -> void:
    player.can_move = true
    start_game()

func start_game() -> void:
    pass