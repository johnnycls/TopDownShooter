extends MeshInstance3D

@export var lifetime: float = 0.1

var material: Material = preload("res://assets/resources/bullet_trail_material.tres")

func create_trail(start_pos: Vector3, end_pos: Vector3) -> void:
    var immediate_mesh = mesh as ImmediateMesh
    immediate_mesh.clear_surfaces()
    immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES)
    
    immediate_mesh.surface_add_vertex(start_pos)
    immediate_mesh.surface_add_vertex(end_pos)
    
    immediate_mesh.surface_end()

    mesh.surface_set_material(0, material)
    await get_tree().create_timer(lifetime).timeout
    queue_free()