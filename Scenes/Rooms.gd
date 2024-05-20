extends Base_Scene

class_name Rooms

# Preloaded room scenes.
const SPAWN_ROOMS: Array = [preload("res://World/Environment/Asset Pack - Roguelike Dungeon/rooms/SpawnRoom_0.tscn")]
const INTERMEDIATE_ROOMS: Array = [preload("res://World/Environment/Asset Pack - Roguelike Dungeon/rooms/room_0.tscn"), preload("res://World/Environment/Asset Pack - Roguelike Dungeon/rooms/room_1.tscn")]
const SPECIAL_ROOMS: Array = [preload("res://World/Environment/Asset Pack - Roguelike Dungeon/rooms/special_room_0.tscn")]
const END_ROOMS: Array = [preload("res://World/Environment/Asset Pack - Roguelike Dungeon/rooms/Room_End_0.tscn")]
const EXIT_ROOMS: Array = [preload("res://World/Environment/Asset Pack - Roguelike Dungeon/rooms/Room_LeaveDungeon_0.tscn")]
const SLIME_BOSS_SCENE: PackedScene = preload("res://World/Environment/Asset Pack - Roguelike Dungeon/rooms/Boss_Room_0.tscn")

const TILE_SIZE: int = 16

@export var num_levels: int = 5
@export var MAX_FLOORS: int = 2

func _ready() -> void:
	super()
	handle_floor_reset()
	_spawn_rooms()

func handle_floor_reset() -> void:
	if player.player_data.dungeon_floor > MAX_FLOORS:
		print("Dungeon previously cleared. handle_floor_reset()")
		reset_player_stats()

	if player.player_data.dungeon_floor == 2:
		print("Boss Floor")
		num_levels = 3

func reset_player_stats() -> void:
	player.player_data.dungeon_floor = 1
	player.player_data.temp_agi = 0
	player.player_data.temp_def = 0
	player.player_data.temp_str = 0

func _spawn_rooms() -> void:
	var previous_room: Node2D
	var special_room_spawned: bool = false

	for i in num_levels:
		var room: Node2D = instantiate_room(i, special_room_spawned)
		if i > 0 and room:
			connect_rooms(previous_room, room)
		add_child(room)
		previous_room = room

func instantiate_room(index: int, special_room_spawned: bool) -> Node2D:
	var room: Node2D
	if index == 0:
		room = SPAWN_ROOMS[randi() % SPAWN_ROOMS.size()].instantiate()
		player.position = room.get_node("PlayerSpawnPos").position
	elif index == num_levels - 1:
		room = get_terminating_room()
	else:
		room = get_intermediate_room(index, special_room_spawned)
	return room

func get_terminating_room() -> Node2D:
	if player.player_data.dungeon_floor == MAX_FLOORS:
		print("MAX FLOOR DETECTED")
		return EXIT_ROOMS[randi() % EXIT_ROOMS.size()].instantiate()
	return END_ROOMS[randi() % END_ROOMS.size()].instantiate()

func get_intermediate_room(index: int, special_room_spawned: bool) -> Node2D:
	if player.player_data.dungeon_floor == 2:
		return SLIME_BOSS_SCENE.instantiate()
	if (randi() % 3 == 0 and not special_room_spawned) or (index == num_levels - 2 and not special_room_spawned):
		return SPECIAL_ROOMS[randi() % SPECIAL_ROOMS.size()].instantiate()
	return INTERMEDIATE_ROOMS[randi() % INTERMEDIATE_ROOMS.size()].instantiate()

func connect_rooms(previous_room: Node2D, room: Node2D) -> void:
	var previous_room_tilemap: TileMap = previous_room.get_node("TileMap")
	var previous_room_door: StaticBody2D = previous_room.get_node("Doors/Door")
	var exit_tile_pos: Vector2i = previous_room_tilemap.local_to_map(previous_room_door.position)
	var corridor_height: int = randi() % 5 + 2
	create_corridor(previous_room_tilemap, exit_tile_pos, corridor_height)
	set_room_position(room, previous_room_door, corridor_height)

func create_corridor(tilemap: TileMap, exit_pos: Vector2i, height: int) -> void:
	for y in range(height + 1):
		tilemap.set_cell(2, exit_pos + Vector2i(-1, -y + 1), 0, Vector2i(3,5)) # Left Wall
		tilemap.set_cell(0, exit_pos + Vector2i(-1, -y + 1), 0, Vector2i(3,1)) # Floor
		tilemap.set_cell(0, exit_pos + Vector2i(0, -y + 1), 0, Vector2i(3,1))  # Floor
		tilemap.set_cell(2, exit_pos + Vector2i(0, -y + 1), 0, Vector2i(4,5))  # Right Wall

func set_room_position(room: Node2D, door: StaticBody2D, corridor_height: int) -> void:
	var room_tilemap: TileMap = room.get_node("TileMap")
	room.position = door.global_position + Vector2.UP * room_tilemap.get_used_rect().size.y * TILE_SIZE + Vector2.UP * corridor_height * TILE_SIZE + Vector2.LEFT * room_tilemap.local_to_map(room.get_node("Entrance/Marker2D2").position).x * TILE_SIZE
