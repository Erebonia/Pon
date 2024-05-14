extends Node2D

const SPAWN_ROOMS: Array = [preload("res://World/Environment/Asset Pack - Roguelike Dungeon/rooms/SpawnRoom_0.tscn")]
const INTERMEDIATE_ROOMS: Array = [preload("res://World/Environment/Asset Pack - Roguelike Dungeon/rooms/room_0.tscn"), preload("res://World/Environment/Asset Pack - Roguelike Dungeon/rooms/room_1.tscn")]
const SPECIAL_ROOMS: Array = [preload("res://World/Environment/Asset Pack - Roguelike Dungeon/rooms/special_room_0.tscn")]
const END_ROOMS: Array = [preload("res://World/Environment/Asset Pack - Roguelike Dungeon/rooms/Room_End_0.tscn")]
const EXIT_ROOMS: Array = [preload("res://World/Environment/Asset Pack - Roguelike Dungeon/rooms/Room_LeaveDungeon_0.tscn")]
const SLIME_BOSS_SCENE: PackedScene = preload("res://World/Environment/Asset Pack - Roguelike Dungeon/rooms/Boss_Room_0.tscn")

const TILE_SIZE: int = 16

@export var num_levels: int = 5
@export var MAX_FLOORS = 2
@onready var player: Player = get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	if player.playerData.dungeonFloor > MAX_FLOORS:
		print("RESETTING FLOOR")
		player.playerData.dungeonFloor = 1
		player.playerData.tempAGI = 0
		player.playerData.tempDEF = 0
		player.playerData.tempSTR = 0

	if player.playerData.dungeonFloor == 2:
		print("Boss Floor")
		num_levels = 3
		
	_spawn_rooms()


func _spawn_rooms() -> void:
	var previous_room: Node2D
	var special_room_spawned: bool = false

	for i in num_levels:
		var room: Node2D

		if i == 0:
			room = SPAWN_ROOMS[randi() % SPAWN_ROOMS.size()].instantiate()
			player.position = room.get_node("PlayerSpawnPos").position
		else:
			if i == num_levels - 1 and player.playerData.dungeonFloor != MAX_FLOORS:
				room = END_ROOMS[randi() % END_ROOMS.size()].instantiate()
			elif i == num_levels - 1 and player.playerData.dungeonFloor == MAX_FLOORS:
				print("MAX FLOOR DETECTED")
				room = EXIT_ROOMS[randi() % EXIT_ROOMS.size()].instantiate() 
			else:
				if player.playerData.dungeonFloor == 2:
					room = SLIME_BOSS_SCENE.instantiate()
				else:
					if (randi() % 3 == 0 and not special_room_spawned) or (i == num_levels - 2 and not special_room_spawned):
						room = SPECIAL_ROOMS[randi() % SPECIAL_ROOMS.size()].instantiate()
						special_room_spawned = true
					else:
						room = INTERMEDIATE_ROOMS[randi() % INTERMEDIATE_ROOMS.size()].instantiate()

			var previous_room_tilemap: TileMap = previous_room.get_node("TileMap")
			var previous_room_door: StaticBody2D = previous_room.get_node("Doors/Door")
			var exit_tile_pos: Vector2i = previous_room_tilemap.local_to_map(previous_room_door.position)

			var corridor_height: int = randi() % 5 + 2
			for y in corridor_height + 1:
				#set_cell(layer, coordinates we want to place, source ID, atlas sheet coords)
				previous_room_tilemap.set_cell(2, exit_tile_pos + Vector2i(-1, -y + 1), 0, Vector2i(3,5)) #Left Wall on sprite atlas
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2i(-1, -y + 1), 0, Vector2i(3,1)) #Floor on sprite atlas
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2i(0, -y + 1), 0, Vector2i(3,1)) #Floor on sprite atlas
				previous_room_tilemap.set_cell(2, exit_tile_pos + Vector2i(0, -y + 1), 0, Vector2i(4,5)) #Right wall on sprite atlas

			var room_tilemap: TileMap = room.get_node("TileMap")
			room.position = previous_room_door.global_position + Vector2.UP * room_tilemap.get_used_rect().size.y * TILE_SIZE + Vector2.UP * (corridor_height) * TILE_SIZE + Vector2.LEFT * room_tilemap.local_to_map(room.get_node("Entrance/Marker2D2").position).x * TILE_SIZE
		add_child(room)
		previous_room = room
