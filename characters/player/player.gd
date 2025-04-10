extends CharacterBody3D

@export var speed: float = 5.0
@export var bullet_scene: PackedScene = preload("res://objects/bullet.tscn")
@export var fire_rate: float = 0.5

@onready var animation_player: AnimationPlayer = $Player/AnimationPlayer

var can_move: bool = false
var can_shoot: bool = true

func _process(_delta: float) -> void:
	if can_move:
		handle_rotation()
		handle_shooting()

func _physics_process(_delta: float) -> void:
	if can_move:
		handle_movement()

func handle_movement() -> void:
	var input_dir = Vector3.ZERO
	input_dir.x = Input.get_axis("move_left", "move_right")
	input_dir.z = Input.get_axis("move_forward", "move_backward")
	input_dir = input_dir.normalized()
	
	if input_dir != Vector3.ZERO:
		animation_player.current_animation = "Armature|Handbag_Walk|baselayer"
		animation_player.play()
	else:
		animation_player.current_animation = "idle_animation/Armature|Idle_02|baselayer"
		animation_player.play()
		
	velocity = input_dir * speed
	move_and_slide()

func handle_rotation() -> void:
	var mouse_pos = get_mouse_world_position()
	var direction = (mouse_pos - global_position).normalized()
	var target_rotation = atan2(direction.x, direction.z)
	rotation.y = target_rotation

func handle_shooting() -> void:
	if Input.is_action_just_pressed("shoot") and can_shoot:
		var bullet = bullet_scene.instantiate()
		get_parent().add_child(bullet)
		bullet.global_position = global_position + (Vector3.UP * 0.1)
		bullet.direction = global_position.direction_to(get_mouse_world_position(bullet.global_position.y))
		
		can_shoot = false
		await Global.wait(fire_rate)
		can_shoot = true
	
func get_mouse_world_position(fixed_y: float = 0.0) -> Vector3:
	var camera = get_viewport().get_camera_3d()
	var viewport = get_viewport()
	var mouse_pos = viewport.get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_direction = camera.project_ray_normal(mouse_pos)
	var delta_y = fixed_y - ray_origin.y
	if ray_direction.y == 0:
		return ray_origin
	var t = delta_y / ray_direction.y
	if t < 0:
		return ray_origin
	return ray_origin + ray_direction * t
