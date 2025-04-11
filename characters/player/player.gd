extends CharacterBody3D

signal dead

@export var speed: float = 5.0
@export var jump_velocity: float = 9.0
@export var fire_rate: float = 0.5
@export var max_health: int = 1
@export var shoot_distance: float = 50.0
@export var shoot_damage: float = 1.0

var bullet_trail: PackedScene = preload("res://objects/bullet_trail.tscn")

@onready var animation_player: AnimationPlayer = $Model/AnimationPlayer
@onready var gun_marker: Marker3D = $GunPosition
@onready var muzzle: Node3D = $Model/Armature/GeneralSkeleton/BoneAttachment3D/revolver/MuzzleFlash
@onready var muzzle_timer: Timer = $Model/Armature/GeneralSkeleton/BoneAttachment3D/revolver/MuzzleFlash/Timer

var gravity: float = 18.0
var can_move: bool = false
var can_shoot: bool = true
var is_shooting: bool = false
var is_jumping: bool = false
var is_celebrating: bool = false
var health: int = max_health

func init() -> void:
	global_position = Vector3.ZERO
	health = max_health

func _process(_delta: float) -> void:
	if can_move and not is_celebrating:
		handle_rotation()
		handle_shooting()

func _physics_process(delta: float) -> void:
	if can_move and not is_celebrating:
		handle_jumping(delta)
		handle_movement()
		if global_position.y < -5:
			dead.emit()

func handle_jumping(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		is_jumping = false
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		is_jumping = true
		animation_player.play("Jump/mixamo_com")

func handle_movement() -> void:
	var input_dir = Vector3.ZERO
	input_dir.x = Input.get_axis("move_left", "move_right")
	input_dir.z = Input.get_axis("move_forward", "move_backward")
	input_dir = input_dir.normalized()
	
	if !is_shooting and !is_jumping:
		if input_dir != Vector3.ZERO:
			animation_player.play("Armature|walking_man|baselayer")
		else:
			animation_player.play("Standing Idle/mixamo_com")
	
	var current_y = velocity.y
	velocity = input_dir * speed
	velocity.y = current_y
	move_and_slide()

func handle_rotation() -> void:
	var mouse_pos = get_mouse_world_position()
	var direction = (mouse_pos - global_position).normalized()
	var target_rotation = atan2(direction.x, direction.z)
	rotation.y = target_rotation

func handle_shooting() -> void:
	if Input.is_action_just_pressed("shoot") and can_shoot:
		var target = get_mouse_world_position()
		var ray_origin = gun_marker.global_position
		var ray_direction = ray_origin.direction_to(target)
		
		var space_state = get_world_3d().direct_space_state
		var ray_end = ray_origin + ray_direction * shoot_distance
		var ray_parameters = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
		ray_parameters.exclude = [self]
		
		var hit = space_state.intersect_ray(ray_parameters)

		var trail = bullet_trail.instantiate()
		get_tree().root.add_child(trail)
		trail.create_trail(
			ray_origin,
			hit.position if hit else ray_end
		)

		if hit and hit.collider is Enemy:
			hit.collider.take_damage(shoot_damage)
		
		is_shooting = true
		can_shoot = false
		
		animation_player.play("Gunplay/mixamo_com")
		shoot_animation()
		muzzle.show()
		muzzle_timer.start()
		
		await Global.wait(fire_rate)
		can_shoot = true

func shoot_animation() -> void:
	await animation_player.animation_finished
	is_shooting = false
	if velocity.x == 0 and velocity.z == 0:
		animation_player.play("Standing Idle/mixamo_com")
	else:
		animation_player.play("Armature|walking_man|baselayer")
	
func get_mouse_world_position() -> Vector3:
	var camera = get_viewport().get_camera_3d()
	var viewport = get_viewport()
	var mouse_pos = viewport.get_mouse_position()
	
	var space_state = get_world_3d().direct_space_state
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_end = ray_origin + camera.project_ray_normal(mouse_pos) * 2000
	var ray_parameters = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	ray_parameters.exclude = [self]  
	
	var intersection = space_state.intersect_ray(ray_parameters)
	
	if intersection:
		return intersection.position
	
	var plane = Plane(Vector3.UP, global_position.y)
	return plane.intersects_ray(ray_origin, camera.project_ray_normal(mouse_pos))

func take_damage(damage: int) -> void:
	health -= damage
	if health <= 0:
		die()

func die() -> void:
	can_move = false
	animation_player.play("die/mixamo_com")
	await animation_player.animation_finished
	dead.emit()

func win() -> void:
	is_celebrating = true
	animation_player.play("Victory/mixamo_com")
	await animation_player.animation_finished
	is_celebrating = false


func _on_timer_timeout() -> void:
	muzzle.hide()
