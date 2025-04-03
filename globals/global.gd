extends Node

@onready var audio = $AudioStreamPlayer

var controller

func _ready() -> void:
	randomize()
	controller = get_input_type()

func is_node_valid(node) -> bool:
	return node != null and is_instance_valid(node) and not node.is_queued_for_deletion()
	
func get_valid_nodes_in_group(group_name: String) -> Array:
	return get_tree().get_nodes_in_group(group_name).filter(func(node):
		return is_node_valid(node)
	)
	
func play_sound(sound: AudioStream, audio_player: AudioStreamPlayer = audio) -> void:
	if is_instance_valid(audio_player) and sound:
		audio_player.stream = sound
		if audio_player.stream:
			audio_player.play()
			await audio_player.finished

func wait(duration: float):
	var timer = get_tree().create_timer(duration)
	await timer.timeout

func get_input_type(): # not supporting html5
	var os = OS.get_name()
	var joy_name = Input.get_joy_name(0)

	if joy_name != "":
		if joy_name.find("Nintendo") != -1:
			return "nintendo"
		elif joy_name.find("PlayStation") != -1:
			return "playstation"
		elif joy_name.find("Steam Deck") != -1:
			return "steam_deck"
		else:
			return "joy"
	else:
		if os == "Android" or os == "iOS" or os == "HarmonyOS":
			return "touch_screen"
		else:
			return "mouse_keyboard"
