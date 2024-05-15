extends Node
class_name SceneManager

var player
var userInterface: UserInterface
var last_scene_name: String 
var scene_dir_path = "res://Scenes/"
var current_scene: String
	
func _process(_delta):
	if get_tree().current_scene != null:
		current_scene = get_tree().current_scene.name
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
	get_tree().call_deferred("change_scene_to_file", full_path)
	AudioManager.get_node("Scene_Transition").play()
	
func removeTemporaryStats():
	if scene_manager.current_scene != "Dungeon_1":
		var player = get_tree().get_first_node_in_group("Player")
		if player.player_data.temp_str > 0 or player.player_data.temp_def > 0 or player.player_data.temp_agi > 0:
			print("Removing temp stats")
			player.player_data.Strength -= player.player_data.temp_str
			player.player_data.Defense -= player.player_data.temp_def
			player.player_data.Agility -= player.player_data.temp_agi
			player.player_data.temp_str = 0
			player.player_data.temp_agi = 0
			player.player_data.temp_def = 0
