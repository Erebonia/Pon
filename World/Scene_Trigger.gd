extends Area2D

class_name SceneTrigger

@export var connected_scene: String #Name of scene to change to
var scene_folder = "res://Scenes/"

func _on_body_entered(body):
	if body is Player:
		body.savePlayerData()
		body.saveDataToFile()
		scene_manager.change_scene(get_owner(), connected_scene)
		scene_manager.current_scene = connected_scene
		removeTemporaryStats(body)

func removeTemporaryStats(player: Player):
	if scene_manager.current_scene != "Dungeon_1":
		if player.player_data.temp_str > 0 or player.player_data.temp_def > 0 or player.player_data.temp_agi > 0:
			print("Removing temp stats")
			player.player_data.Strength -= player.player_data.temp_str
			player.player_data.Defense -= player.player_data.temp_def
			player.player_data.Agility -= player.player_data.temp_agi
			player.player_data.temp_str = 0
			player.player_data.temp_agi = 0
			player.player_data.temp_def = 0
