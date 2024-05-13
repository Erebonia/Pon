extends Node2D
class_name DungeonRoom

@export var boss_room: bool = false

const SPAWN_EXPLOSION_SCENE: PackedScene = preload("res://World/Environment/Asset Pack - Roguelike Dungeon/spawn_explosion.tscn")

const ENEMY_SCENES: Dictionary = {
	"FLYING_CREATURE": preload("res://Enemies/Scenes/enemy_bat.tscn"),
	"GOBLIN": preload("res://Enemies/Scenes/enemy_bat.tscn"), "SLIME_BOSS": preload("res://Enemies/Scenes/boss_golem.tscn")
}

var num_enemies: int

@onready var tilemap: TileMap = $TileMap
@onready var entrance: Node2D = get_node("Entrance")
@onready var door_container: Node2D = get_node("Doors")
@onready var enemy_positions_container: Node2D = get_node("EnemyPositions")
@onready var player_detector: Area2D = get_node("PlayerDetector")
@onready var cardSelect = null


func _ready() -> void:
	num_enemies = enemy_positions_container.get_child_count()
	cardSelect = get_tree().get_first_node_in_group("CardSelection")
	#if Status.dungeonFloor > 1:
	cardSelect.visible = true

func _on_enemy_killed() -> void:
	num_enemies -= 1
	if num_enemies == 0:
		_open_doors()


func _open_doors() -> void:
	for door in door_container.get_children():
		door.open()


func _close_entrance() -> void:
	for entry_position in entrance.get_children():
		tilemap.set_cell(2, tilemap.local_to_map(entry_position.position), 0, Vector2i(2,7))
		tilemap.set_cell(1, tilemap.local_to_map(entry_position.position) + Vector2i.DOWN, 0, Vector2i(7,4))


func _spawn_enemies() -> void:
	var boss_Spawned = false
	for enemy_position in enemy_positions_container.get_children():
		var enemy: CharacterBody2D
		if boss_room and !boss_Spawned:
			enemy = ENEMY_SCENES.SLIME_BOSS.instantiate()
			boss_Spawned = true
		else:
			if randi() % 2 == 0:
				enemy = ENEMY_SCENES.FLYING_CREATURE.instantiate()
			else:
				enemy = ENEMY_SCENES.GOBLIN.instantiate() 
				
		enemy.connect("tree_exited", Callable(self, "_on_enemy_killed"))
		enemy.position = enemy_position.position
		call_deferred("add_child", enemy)

		var spawn_explosion: AnimatedSprite2D = SPAWN_EXPLOSION_SCENE.instantiate()
		spawn_explosion.position = enemy_position.position
		call_deferred("add_child", spawn_explosion)

func _on_PlayerDetector_body_entered(_body: CharacterBody2D) -> void:
	player_detector.queue_free()
	if num_enemies > 0:
		_close_entrance()
		_spawn_enemies()
	else:
		_close_entrance()
		_open_doors()
		
func _on_increment_level_body_entered(body):
	if body.has_method("player"):
		body.stats.dungeonFloor += 1
		print("Current Floor:" + str(body.stats.dungeonFloor))
