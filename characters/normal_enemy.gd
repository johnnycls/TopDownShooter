class_name NormalEnemy extends Enemy

@export var speed: float = 4.5
@export var attack_range: float = 0.6

@export var attack_animation: String = ""
@export var idle_animation: String = ""
@export var run_animation: String = ""

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
		if run_animation != "":
			animation_player.play(run_animation)
	else:
		if idle_animation != "":
			animation_player.play(idle_animation)
	move_and_slide()
	
	var target_pos = Vector3(player.global_position.x, global_position.y, player.global_position.z)
	look_at(target_pos, Vector3.UP)

func attack() -> void:
	is_attacking = true
	if attack_animation != "":
		animation_player.play(attack_animation)
		await animation_player.animation_finished
	is_attacking = false
