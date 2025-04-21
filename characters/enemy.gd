class_name Enemy extends CharacterBody3D

signal enemy_died

var bounce_sound: AudioStream = preload("res://assets/sound_effects/bounce.mp3")

@export var health: int = 1
@export var touch_damage: int = 1
@export var die_animation: String = ""
@export var bounce_force: float = 7.5

@onready var animation_player: AnimationPlayer = $Model/AnimationPlayer
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var killzone: Area3D = $Killzone

var is_dead: bool = false
var player: Node3D = null


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	if not player:
		queue_free()
		return
	killzone.connect("body_entered", _on_killzone_body_entered)

func take_damage(damage: int) -> void:
	if not is_dead:
		health -= damage
		if health <= 0:
			die()

func play_die_animation() -> void:
	if die_animation != "":
		animation_player.play(die_animation)
		await animation_player.animation_finished

func die() -> void:
	is_dead = true
	await play_die_animation()
	enemy_died.emit()
	queue_free()

func _on_killzone_body_entered(body: Node3D) -> void:
	if not is_dead and body.is_in_group("player"):
		Global.play_sound(bounce_sound, audio_stream_player)
		body.velocity.y = max(bounce_force, body.velocity.y)
		take_damage(1)
