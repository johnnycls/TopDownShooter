class_name Enemy extends CharacterBody3D

@export var health: float = 1.0

var player: Node3D = null

func _ready() -> void:
    initialize()

func initialize() -> void:
    player = get_tree().get_first_node_in_group("player")
    if not player:
        queue_free()
        return

func _physics_process(_delta: float) -> void:
    handle_movement()
    
func handle_movement() -> void:
    pass

func take_damage(damage: float) -> void:
    health -= damage
    if health <= 0:
        die()

func die() -> void:
    queue_free()