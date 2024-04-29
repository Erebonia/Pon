extends Node2D

var checkTime = DayAndNight.get_child(1)

func _ready():
	if global.game_first_loadin == true:
		$Player.position.x = global.player_start_posx
		$Player.position.y = global.player_start_posy
	else:
		$Player.position.x = global.player_exit_boss_posx
		$Player.position.y = global.player_exit_boss_posy
	checkTime.connect("time_tick", Callable(self, "_on_check_time"))
	
func _process(_delta):
	change_scene()

func _on_boss_transition_body_entered(body):
	if body.has_method("player"):
		print("Player entered transition area.")
		global.transition_scene = true

func _on_boss_transition_body_exited(body):
	if body.has_method("player"):
		global.transition_scene = false

func change_scene():
	if global.transition_scene == true:
		if global.current_scene == "world":
			get_tree().change_scene_to_file("res://Enemies/Scenes/boss_room.tscn")
			global.game_first_loadin = false
			global.finish_changescenes()


func _on_check_time(_day, hour, _minute):
	#24 hour Clock
	if (hour >= 19 and hour <= 23) or (hour >= 0 and hour < 5):
		$"Environment/Day Godrays".visible = false
		$"Environment/Night Godrays".visible = true
		$Environment/FogShader.visible = true
	else:
		$"Environment/Day Godrays".visible = true
		$"Environment/Night Godrays".visible = false
		$Environment/FogShader.visible = false


func _on_inventory_gui_opened():
	get_tree().paused = true

func _on_inventory_gui_closed():
	get_tree().paused = false
