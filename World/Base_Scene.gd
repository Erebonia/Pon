extends Node
class_name Base_Scene

@onready var player : Player = $Player
@onready var entrance_markers: Node2D = $EntranceMarkers

func _ready():		
	#player.loadSaveData()
	removeTemporaryStats()
	position_player()
		
func position_player() -> void:
	var last_scene = scene_manager.last_scene_name.to_lower().replace('_', '').replace(' ', '')

	if last_scene.is_empty():
		last_scene = "any"
		
	for entrance in entrance_markers.get_children():
		var entrance_name = entrance.name.to_lower().replace('_', '').replace(' ', '')
		
		if entrance is Marker2D and entrance_name == "any" or entrance_name == last_scene:
			player.global_position = entrance.global_position
			
func removeTemporaryStats():
	if scene_manager.current_scene != "Dungeon_1":
		if player.player_data.temp_str > 0 or player.player_data.temp_def > 0 or player.player_data.temp_agi > 0:
			player.player_data.Strength -= player.player_data.temp_str
			player.player_data.Defense -= player.player_data.temp_def
			player.player_data.Agility -= player.player_data.temp_agi
			player.player_data.temp_str = 0
			player.player_data.temp_agi = 0
			player.player_data.temp_def = 0
