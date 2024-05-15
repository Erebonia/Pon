extends Node
class_name SceneManager

var player : Player
var last_scene_name: String 
var current_scene: String
var scene_dir_path = "res://Scenes/"
	
func _process(_delta):
	if get_tree().current_scene != null:
		current_scene = get_tree().current_scene.name
		#removeTemporaryStats()

func change_scene(from, to_scene_name: String) -> void:
	last_scene_name = from.name
	print("Last Scene: " + last_scene_name)
	
	player = from.player
	player.get_parent().remove_child(player)
		
	# Fade effect
	TransitionScene.transition() 
	AudioManager.get_node("Footsteps_Grass").stop()
	AudioManager.get_node("Footsteps_Stone").stop()
	AudioManager.get_node("Scene_Transition").play()
	
	#Change Scene
	var full_path = scene_dir_path + to_scene_name + ".tscn"
	from.get_tree().call_deferred("change_scene_to_file", full_path)
	
func removeTemporaryStats():
	if scene_manager.current_scene != "Dungeon_1":
		if player.player_data.temp_str > 0 or player.player_data.temp_def > 0 or player.player_data.temp_agi > 0:
			print("Removing temp stats")
			player.player_data.Strength -= player.player_data.temp_str
			player.player_data.Defense -= player.player_data.temp_def
			player.player_data.Agility -= player.player_data.temp_agi
			player.player_data.temp_str = 0
			player.player_data.temp_agi = 0
			player.player_data.temp_def = 0
