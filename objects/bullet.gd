extends Area3D

@export var speed: float = 40.0
@export var damage: int = 1

var direction: Vector3

func _process(delta: float) -> void:
	global_position += direction * speed * delta

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("enemy"):
		body.take_damage(damage)
		queue_free()

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()
