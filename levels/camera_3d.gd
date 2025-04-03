extends Camera3D

@export var target: Node
@export var offset: Vector3 = Vector3(0, 10, 5)
@export var smooth_speed: float = 0.1


func _process(_delta: float) -> void:
	if target:
		global_position = target.position + offset
		look_at(target.global_position, Vector3.UP)
