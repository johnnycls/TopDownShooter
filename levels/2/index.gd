extends SingleSceneLevel

func _ready() -> void:
    super._ready()
    BgmPlayer.stop_bgm()
    Dialogic.start("lv2")

func start() -> void:
    super.start()
    BgmPlayer.play_bgm(1)