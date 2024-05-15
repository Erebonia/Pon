extends Node

class_name BaseScene

@onready var player : Player = $Player
@onready var entrance_markers: Node2D = $EntranceMarkers

func _ready():
	if scene_manager.player:
		if player:
			player.queue_free()
			
		player = scene_manager.player
		add_child(player)
		position_player()
		
func position_player() -> void:
	var last_scene = scene_manager.last_scene_name.to_lower().replace('_', '').replace(' ', '')

	if last_scene.is_empty():
		last_scene = "any"
		
	for entrance in entrance_markers.get_children():
		var entrance_name = entrance.name.to_lower().replace('_', '').replace(' ', '')
		
		if entrance is Marker2D and entrance_name == "any" or entrance_name == last_scene:
			player.global_position = entrance.global_position
			
