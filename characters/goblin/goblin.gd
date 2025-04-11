extends CharacterBody3D

@export var speed: float = 5.0
@export var attack_range: float = 2.0
@export var health: float = 1.0

@onready var animation_player: AnimationPlayer = $Goblin/AnimationPlayer
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

var player: Node3D = null
var dead: bool = false

func _ready() -> void:
    player = get_tree().get_first_node_in_group("player")
    if not player:
        queue_free()
        return
        
    nav_agent.target_position = player.global_position

func _physics_process(_delta: float) -> void:
    if dead:
        return
        
    nav_agent.target_position = player.global_position
    
    if nav_agent.is_navigation_finished():
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

func take_damage(damage: float) -> void:
    health -= damage
    if health <= 0:
        die()

func die() -> void:
    dead = true
    queue_free()