extends Node
class_name SceneManager

var player: Player
var userInterface: UserInterface
var last_scene_name: String 
var scene_dir_path = "res://scenes/"
var currentScene: String

func _process(_delta):
	if get_tree().current_scene != null:
		currentScene = get_tree().current_scene.name

func change_scene(from, to_scene_name: String) -> void:
	last_scene_name = from.name
	if player != null:
		player = from.player
		player.get_parent().remove_child(player)
		
	# Fade effect
	TransitionScene.transition() 
	
	#Change Scene
	var full_path = scene_dir_path + to_scene_name + ".tscn"
	from.get_tree().call_deferred("change_scene_to_file", full_path)
	AudioManager.get_node("Scene_Transition").play()
