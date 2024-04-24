extends Node2D

func _ready():
	if global.game_first_loadin == true:
		$Player.position.x = global.player_start_posx
		$Player.position.y = global.player_start_posy
	else:
		$Player.position.x = global.player_exit_boss_posx
		$Player.position.y = global.player_exit_boss_posy
	
func _process(_delta):
	change_scene()

func _on_boss_transition_body_entered(body):
	print("Player entered transition area.")
	if body.has_method("player"):
		global.transition_scene = true

func _on_boss_transition_body_exited(body):
	if body.has_method("player"):
		global.transition_scene = false

func change_scene():
	if global.transition_scene == true:
		if global.current_scene == "world":
			get_tree().change_scene_to_file("res://boss_room.tscn")
			global.game_first_loadin = false
			global.finish_changescenes()
