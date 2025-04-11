class_name Level extends Node3D

@export var spawn_radius: float = 20.0
@export var spawn_interval: float = 2.0
@export var goblin_enemy_count: int = 20
@export var wolf_enemy_count: int = 0
@export var imp_enemy_count: int = 0
@export var goblin_wizard_enemy_count: int = 0
@export var boss_enemy_count: int = 0

@onready var player: Node3D = $Player
@onready var spawn_timer: Timer = $SpawnTimer
@onready var map: NavigationRegion3D = $Map

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
    map.bake_navigation_mesh()
    
func _on_timeline_started() -> void:
    player.can_move = false
    Main.can_open_menu = false

func _on_timeline_ended() -> void:
    start()

func start() -> void:
    player.can_move = true
    Main.can_open_menu = true
    initialize_enemy_counts()
    spawn_timer.start()

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
