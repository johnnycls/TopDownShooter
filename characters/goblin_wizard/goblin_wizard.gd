extends NormalEnemy

@export var bullet_count: int = 3
@export var spread_angle: float = 30.0

var fire_bullet_scene = preload("res://objects/fire_bullet.tscn")

func attack() -> void:
    super.attack()
    
    var base_direction = global_position.direction_to(player.global_position)
    var start_angle = -spread_angle / 2
    var angle_step = spread_angle / (bullet_count - 1) if bullet_count > 1 else 0.0
    
    for i in bullet_count:
        var bullet = fire_bullet_scene.instantiate()
        get_parent().add_child(bullet)
        bullet.global_position = global_position + Vector3.UP
        
        var angle = deg_to_rad(start_angle + angle_step * i)
        var rotated_direction = base_direction.rotated(Vector3.UP, angle)
        bullet.direction = rotated_direction