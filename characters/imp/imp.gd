extends NormalEnemy

var dark_bullet_scene = preload("res://objects/dark_bullet.tscn")

func attack() -> void:
    super.attack()

    var bullet = dark_bullet_scene.instantiate()
    get_parent().add_child(bullet)
    bullet.global_position = global_position + Vector3.UP
    
    var direction = global_position.direction_to(player.global_position)
    bullet.direction = direction