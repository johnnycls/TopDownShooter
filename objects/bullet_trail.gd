extends MeshInstance3D

@export var lifetime: float = 0.05
@export var segments: int = 8
@export var radius: float = 0.01

var material: Material = preload("res://assets/resources/bullet_trail_material.tres")

func create_trail(start_pos: Vector3, end_pos: Vector3) -> void:
    var immediate_mesh = mesh as ImmediateMesh
    immediate_mesh.clear_surfaces()
    immediate_mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES)
    
    var direction = end_pos - start_pos
    var forward = direction.normalized()
    
    var up = Vector3.UP
    if forward.dot(up) > 0.9:
        up = Vector3.RIGHT
    var right = forward.cross(up).normalized()
    up = right.cross(forward).normalized()
    
    for i in segments:
        var angle1 = 2 * PI * i / segments
        var angle2 = 2 * PI * (i + 1) / segments
        
        var v1 = start_pos + (right * cos(angle1) + up * sin(angle1)) * radius
        var v2 = end_pos + (right * cos(angle1) + up * sin(angle1)) * radius
        var v3 = start_pos + (right * cos(angle2) + up * sin(angle2)) * radius
        var v4 = end_pos + (right * cos(angle2) + up * sin(angle2)) * radius
        
        immediate_mesh.surface_add_vertex(v1)
        immediate_mesh.surface_add_vertex(v2)
        immediate_mesh.surface_add_vertex(v3)
        
        immediate_mesh.surface_add_vertex(v2)
        immediate_mesh.surface_add_vertex(v4)
        immediate_mesh.surface_add_vertex(v3)
    
    immediate_mesh.surface_end()
    
    mesh.surface_set_material(0, material)
    await get_tree().create_timer(lifetime).timeout
    queue_free()