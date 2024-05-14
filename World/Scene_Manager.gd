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
	if scene_manager.currentScene != "Dungeon_1":
		var player = get_tree().get_first_node_in_group("Player")
		if player.playerData.temp_str > 0 or player.playerData.temp_def > 0 or player.playerData.temp_agi > 0:
			print("Removing temp stats")
			player.playerData.Strength -= player.playerData.temp_str
			player.playerData.Defense -= player.playerData.temp_def
			player.playerData.Agility -= player.playerData.temp_agi
			player.playerData.temp_str = 0
			player.playerData.temp_agi = 0
			player.playerData.temp_def = 0
