extends Area2D

class_name SceneTrigger

@export var connected_scene: String #Name of scene to change to
var scene_folder = "res://scenes/"


func _on_body_entered(body):
	if body is Player:
		scene_manager.change_scene(get_owner(), connected_scene)
