extends Enemy

@export var speed: float = 4.5
@export var attack_range: float = 0.6
@export var bullet_count: int = 8
@export var spread_angle: float = 100.0
@export var attack_cooldown: float = 0.6
@export var teleport_min_time: float = 1.5
@export var teleport_max_time: float = 3.5
@export var teleport_radius: float = 10.0

var fire_bullet_scene = preload("res://objects/fire_bullet.tscn")

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var teleport_timer: Timer = $TeleportTimer

var is_attacking: bool = false
var can_teleport: bool = true

func _ready() -> void:
	super._ready()
	nav_agent.target_position = player.global_position
	setup_teleport_timer()

func setup_teleport_timer() -> void:
	teleport_timer = Timer.new()
	add_child(teleport_timer)
	teleport_timer.one_shot = true
	teleport_timer.timeout.connect(teleport)
	start_teleport_timer()

func start_teleport_timer() -> void:
	var random_delay = randf_range(teleport_min_time, teleport_max_time)
	teleport_timer.start(random_delay)

func teleport() -> void:
	if is_dead:
		return
		
	var random_angle = randf() * PI * 2
	var teleport_pos = Vector3(
		player.global_position.x + cos(random_angle) * teleport_radius,
		0,
		player.global_position.z + sin(random_angle) * teleport_radius
	)
	
	global_position = teleport_pos
	
	var target_pos = player.global_position
	look_at(target_pos, Vector3.UP)
	
	start_teleport_timer()

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
	
	move_and_slide()
	
	var target_pos = Vector3(player.global_position.x, global_position.y, player.global_position.z)
	look_at(target_pos, Vector3.UP)

func attack() -> void:
	is_attacking = true
	await Global.wait(attack_cooldown)
	is_attacking = false

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
