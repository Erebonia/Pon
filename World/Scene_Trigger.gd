extends Area2D
class_name Scene_Trigger

@export var connected_scene: String #Name of scene to change to
var scene_folder = "res://Scenes/"

func _on_body_entered(body):
	if body is Player:
		body.savePlayerData()
		body.saveDataToFile()
		scene_manager.change_scene(get_owner(), connected_scene)
		scene_manager.current_scene = connected_scene

