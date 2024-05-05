extends Node2D
class_name EnemyState

@export var enemy : Enemy_Base
@onready var StateMachine = $".."
@onready var animation_player = owner.find_child("AnimationPlayer")
var player: CharacterBody2D

func _ready():
	pass

func Enter() -> void:
	player = get_parent().get_parent().find_child("Player")
	
func Exit() -> void:
	pass
	
func Process(_delta : float) -> EnemyState:
	return null
	
func Physics( _delta : float) -> EnemyState:
	return null

func HandleInput(_event: InputEvent) -> EnemyState:
	return null
