extends Node2D
class_name State

@onready var player : Player = get_tree().get_first_node_in_group("Player")
@onready var state_machine = $".."

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
		

