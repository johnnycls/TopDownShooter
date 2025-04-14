extends MarginContainer

@onready var remaining_enemies_label: Label = $CenterContainer/PanelContainer/RemainingEnemyLabel

func update_status(new_status: Dictionary) -> void:
	remaining_enemies_label.text = str(new_status["remaining_enemies"])
	
func _on_pause_button_pressed() -> void:
	Main.open_menu()
