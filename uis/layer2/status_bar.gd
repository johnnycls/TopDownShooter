extends CanvasLayer

var status_bar_content_scene: PackedScene = preload("res://uis/layer2/status_bar_content.tscn")

var status_bar_content: Control = null

func close() -> void:
	if status_bar_content != null:
		status_bar_content.queue_free()
		status_bar_content = null

func open() -> void:
	if status_bar_content == null:
		status_bar_content = status_bar_content_scene.instantiate()
		add_child(status_bar_content)

func update_status(new_status: Dictionary) -> void:
	if status_bar_content!=null:
		status_bar_content.update_status(new_status)
