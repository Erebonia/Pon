extends Node2D
class_name EnemyState

static var enemy : EnemyBoss
static var player : Player
@onready var StateMachine = $".."
@onready var animation_player = owner.find_child("AnimationPlayer")

func _ready():
	pass

func Enter() -> void:
	pass
	
func Exit() -> void:
	pass
	
func Process(_delta : float) -> EnemyState:
	return null
	
func Physics( _delta : float) -> EnemyState:
	return null

func HandleInput(_event: InputEvent) -> EnemyState:
	return null
