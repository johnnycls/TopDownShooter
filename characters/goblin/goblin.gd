extends Enemy

@export var speed: float = 6.0
@export var attack_damage: float = 1.0

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

var is_attacking: bool = false

func _ready() -> void:
    super._ready()
    nav_agent.target_position = player.global_position

func _physics_process(_delta: float) -> void:
    if is_dead or is_attacking:
        return
        
    nav_agent.target_position = player.global_position
    var distance_to_player = global_position.distance_to(player.global_position)
    
    if distance_to_player <= attack_range:
        attack()
        return
        
    var next_position: Vector3 = nav_agent.get_next_path_position()
    var direction: Vector3 = global_position.direction_to(next_position)
    velocity = direction * speed
    
    if direction.length() > 0:
        animation_player.play("Armature|running|baselayer")
    else:
        animation_player.play("Orc Idle/mixamo_com")
    move_and_slide()
    
    var target_pos = Vector3(player.global_position.x, global_position.y, player.global_position.z)
    look_at(target_pos, Vector3.UP)

func attack() -> void:
    is_attacking = true
    animation_player.play("Zombie Attack/mixamo_com")
    if player and global_position.distance_to(player.global_position) <= attack_range:
        player.take_damage(attack_damage)
    await animation_player.animation_finished
    is_attacking = false