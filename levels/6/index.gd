extends SingleSceneLevel

func _ready() -> void:
    super._ready()
    BgmPlayer.stop_bgm()
    Dialogic.start("lv6")

func start() -> void:
    super.start()
    BgmPlayer.play_bgm(5)

func win() -> void:
    Main.win()
    player.win()
    BgmPlayer.play_bgm(2)
    await BgmPlayer.finished
    Dialogic.start("end")