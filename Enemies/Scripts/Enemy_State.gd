extends Node2D
class_name EnemyState

@export var enemy : CharacterBody2D
@onready var StateMachine = $".."
@onready var animation_player = owner.find_child("AnimationPlayer")
var player: CharacterBody2D

func _ready():
	pass

func Enter() -> void:
	pass
	
func Exit() -> void:
	pass
	
func Process(_delta : float) -> EnemyState:
	player = get_tree().get_first_node_in_group("Player")
	return null
	
func Physics( _delta : float) -> EnemyState:
	return null

func HandleInput(_event: InputEvent) -> EnemyState:
	return null
