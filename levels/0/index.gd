extends Level

@export_group("Enemy Counts")
@export var spawn_int: float = 2.0
@export var goblin_count: int = 20
@export var wolf_count: int = 0
@export var imp_count: int = 0
@export var wizard_count: int = 0
@export var boss_count: int = 0

func _ready() -> void:
    spawn_interval = spawn_int
    goblin_enemy_count = goblin_count
    wolf_enemy_count = wolf_count
    imp_enemy_count = imp_count
    goblin_wizard_enemy_count = wizard_count
    boss_enemy_count = boss_count
    super._ready()
    Dialogic.start("lv0")
