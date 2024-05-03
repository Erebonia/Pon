extends Node2D
	
func _process(_delta):
	change_scene()

func change_scene():
	if global.transition_scene == true:
		print(global.current_scene)
		if global.current_scene == "boss_room":
			get_tree().change_scene_to_file("res://World/world.tscn")
			global.finish_changescenes()

func _on_exit_to_world_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true

func _on_exit_to_world_body_exited(body):
	if body.has_method("player"):
		global.transition_scene = false
