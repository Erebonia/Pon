extends Node2D
class_name State

static var player : Player
@onready var StateMachine = $".."

func _ready():
	pass

func Enter() -> void:
	pass
	
func Exit() -> void:
	pass
	
func Process(_delta : float) -> State:
	return null
	
func Physics( _delta : float) -> State:
	return null

func HandleInput(_event: InputEvent) -> State:
	return null
