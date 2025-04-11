class_name Enemy extends CharacterBody3D

signal enemy_died

@export var health: int = 1
@export var attack_range: float = 1.0

@onready var animation_player: AnimationPlayer = $Model/AnimationPlayer
@onready var collision_shape: CollisionShape3D = $CollisionShape3D

var is_dead: bool = false

var player: Node3D = null

func _ready() -> void:
    player = get_tree().get_first_node_in_group("player")
    if not player:
        queue_free()
        return

func take_damage(damage: int) -> void:
    health -= damage
    if health <= 0:
        die()

func die_animation() -> void:
    animation_player.play("die/mixamo_com")
    await animation_player.animation_finished

func die() -> void:
    is_dead = true
    await die_animation()
    enemy_died.emit()
    queue_free()