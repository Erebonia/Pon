extends Node
class_name SceneManager

var player: Player
var last_scene_name: String 
var scene_dir_path = "res://scenes/"

func change_scene(from, to_scene_name: String) -> void:
	last_scene_name = from.name
	player = from.player
	player.get_parent().remove_child(player)

	var full_path = scene_dir_path + to_scene_name + ".tscn"
	from.get_tree().call_deferred("change_scene_to_file", full_path)
