class_name Bullet extends Area3D

@export var speed: float = 20.0
@export var damage: int = 1

var direction: Vector3

func _process(delta: float) -> void:
	global_position += direction * speed * delta

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()
