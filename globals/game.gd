extends Node2D

var guide_popup = preload("res://uis/layer3/guide.tscn")

var _current_scene: Node

func _remove_scene() -> void:
	if Global.is_node_valid(_current_scene):
		_current_scene.queue_free()
		_current_scene = null
		
	#Main.popup(guide_popup.instantiate())
	
func start_game(level: int) -> void:	
	_remove_scene()
	_current_scene = load("res://levels/"+str(level)+"/index.tscn").instantiate()
	add_child(_current_scene)
		
func end_game() -> void:
	_remove_scene()
