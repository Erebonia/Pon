extends Node
class_name SceneManager

var player
var userInterface: UserInterface
var last_scene_name: String 
var scene_dir_path = "res://Scenes/"
var currentScene: String
	
func _process(_delta):
	if get_tree().current_scene != null:
		currentScene = get_tree().current_scene.name
		removeTemporaryStats()
		
func change_scene(from, to_scene_name: String) -> void:
	last_scene_name = from.name
	if player != null:
		player = from.player
		player.get_parent().remove_child(player)
		
	# Fade effect
	TransitionScene.transition() 
	AudioManager.get_node("Footsteps_Grass").stop()
	AudioManager.get_node("Footsteps_Stone").stop()
	
	#Change Scene
	var full_path = scene_dir_path + to_scene_name + ".tscn"
	from.get_tree().call_deferred("change_scene_to_file", full_path)
	AudioManager.get_node("Scene_Transition").play()
	
func removeTemporaryStats():
	if scene_manager.currentScene != "Dungeon_1" and player != null:
		var playerStats = player.get_node("Stats")
		playerStats.Strength = player.stats.Strength - player.stats.tempSTR
		playerStats.Defense = player.stats.Defense - player.stats.tempDEF
		playerStats.Agility = player.stats.Agility - player.stats.tempAGI
		playerStats.tempSTR = 0
		playerStats.tempAGI = 0
		playerStats.tempDEF = 0
