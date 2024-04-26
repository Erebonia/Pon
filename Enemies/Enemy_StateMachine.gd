extends Node2D
class_name EnemyStateMachine

var states: Array[EnemyState]
var prev_state: EnemyState

var current_state: EnemyState

func _ready():
	process_mode = Node2D.PROCESS_MODE_DISABLED
	
func _process(delta):
	ChangeState(current_state.Process(delta))
	
func _physics_process(delta):
	ChangeState(current_state.Physics(delta))
	
func _unhandled_input(event):
	ChangeState(current_state.HandleInput(event))
	
func Initialize(_enemy: EnemyBoss):
	states = []
	
	for c in get_children():
		if c is EnemyState:
			states.append(c)
			
	if states.size() > 0:
		states[0].enemy = _enemy
		ChangeState(states[0])
		process_mode = Node2D.PROCESS_MODE_INHERIT
	
func ChangeState(new_state: EnemyState):
	if new_state == null or new_state == current_state:
		return
		
	if current_state:
		current_state.Exit()
		
	prev_state = current_state
	current_state = new_state
	current_state.Enter()
