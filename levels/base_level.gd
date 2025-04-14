class_name Level extends Node3D

@export var spawn_radius: float = 28.0
@export var spawn_interval: float
@export var goblin_enemy_count: int
@export var wolf_enemy_count: int
@export var imp_enemy_count: int
@export var goblin_wizard_enemy_count: int
@export var boss_enemy_count: int

@onready var player: Node3D = $Player
@onready var spawn_timer: Timer = $SpawnTimer

var goblin_scene: PackedScene = preload("res://characters/goblin/goblin.tscn")
var wolf_scene: PackedScene = preload("res://characters/wolf/wolf.tscn")
var imp_scene: PackedScene = preload("res://characters/imp/imp.tscn")
var goblin_wizard_scene: PackedScene = preload("res://characters/goblin_wizard/goblin_wizard.tscn")
var boss_scene: PackedScene = preload("res://characters/boss/boss.tscn")
var remaining_enemies = {}

func _ready() -> void:
	Dialogic.timeline_started.connect(_on_timeline_started)
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	setup_spawn_timer()
	player.dead.connect(_on_player_dead)
	
func _on_timeline_started() -> void:
	player.can_move = false
	Main.can_open_menu = false

func _on_timeline_ended() -> void:
	start()

func start() -> void:
	for child in get_children():
		if child is Enemy or child.is_in_group("bullet"):
			child.queue_free()
	Main.can_open_menu = true
	initialize_enemy_counts()
	spawn_timer.start()
	player.can_move = true
	player.init()

func setup_spawn_timer() -> void:
	spawn_timer.wait_time = spawn_interval
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)

func initialize_enemy_counts() -> void:
	remaining_enemies = {
		"goblin": goblin_enemy_count,
		"wolf": wolf_enemy_count,
		"imp": imp_enemy_count, 
		"goblin_wizard": goblin_wizard_enemy_count,
		"boss": boss_enemy_count,
	}

func _on_spawn_timer_timeout() -> void:
	spawn_enemy()

func spawn_enemy() -> void:
	var enemy_type = choose_enemy_type()
	if enemy_type == "none":
		spawn_timer.stop()
		return
		
	var enemy_scene = get_enemy_scene(enemy_type)
	var enemy = enemy_scene.instantiate()
	
	var angle = randf() * PI * 2
	var spawn_pos = Vector3(
		cos(angle) * spawn_radius,
		0,
		sin(angle) * spawn_radius
	)
	
	enemy.position = spawn_pos
	enemy.enemy_died.connect(check_win_condition)
	add_child(enemy)
	remaining_enemies[enemy_type] -= 1

func choose_enemy_type() -> String:
	var total_weight: float = 0
	var weights = {}
	
	for type in remaining_enemies.keys():
		if remaining_enemies[type] > 0:
			weights[type] = remaining_enemies[type]
			total_weight += remaining_enemies[type]
	
	if total_weight <= 0:
		return "none"
	
	var random_value = randf() * total_weight
	var current_weight = 0
	
	for type in weights:
		current_weight += weights[type]
		if random_value <= current_weight:
			return type
	
	return "none"

func get_enemy_scene(enemy_type: String) -> PackedScene:
	match enemy_type:
		"goblin":
			return goblin_scene
		"wolf":
			return wolf_scene
		"imp":
			return imp_scene
		"goblin_wizard":
			return goblin_wizard_scene
		"boss":
			return boss_scene
		_:
			push_error("Unknown enemy type: " + enemy_type)
			return null

func _on_player_dead() -> void:
	start()

func check_win_condition() -> void:
	var no_remaining = remaining_enemies.values().all(func(count): return count <= 0)
	var no_alive = not get_children().any(func(child): 
		return child is Enemy and not child.is_dead
	)

	if no_remaining and no_alive:
		Main.win()
		await player.win()
		Main.back_to_level_selection()
