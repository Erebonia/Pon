extends Node
class_name State

static var player : Player
@onready var state_machine = $".."

func _ready():
	pass

func Enter():
	pass
	
func Exit() -> void:
	pass
	
func Process(_delta : float) -> State:
	return null
	
func Physics( _delta : float) -> State:
	return null

func HandleInput(_event: InputEvent) -> State:
	return null
