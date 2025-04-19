extends Level

func _ready() -> void:
    super._ready()
    BgmPlayer.play_bgm(1)
    Dialogic.start("lv0")
