extends Camera3D

@export var target: Node
@export var offset: Vector3 = Vector3(0, 7.5, 6)

func _process(_delta: float) -> void:
    if target:
        var target_pos = Vector3(target.position.x, 0, target.position.z)
        global_position = target_pos + offset
        look_at(target_pos, Vector3.UP)
