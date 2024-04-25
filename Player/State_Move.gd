extends State
class_name State_Move

#Speed
@export var ACCELERATION = 500
@export var MAX_SPEED = 100
@export var ROLL_SPEED = 125
@export var Friction = 500

@onready var idle : State = $"../Idle"
@onready var roll : State = $"../Roll"
@onready var attack = $"../Attack"

func Enter():
	player.UpdateAnimation("Run")
	
func Exit():
	pass
	
func Process(_delta : float) -> State:
	return null
	
func Physics(delta : float) -> State:
	
	if Input.is_action_just_pressed("roll"):
		return roll
	
	if Input.is_action_pressed("attack"):
		return attack
		
	move_state(delta)
	
	return null
	
func move_state(delta):
		if player.input_vector != Vector2.ZERO: 
			roll.roll_vector = player.input_vector
			player.velocity = player.velocity.move_toward(player.input_vector * MAX_SPEED, ACCELERATION * delta) # This will be the direction we move to
			player.animationTree.set("parameters/Run/blend_position", player.input_vector)
			player.animationTree.set("parameters/Idle/blend_position", player.input_vector)
			player.aim_direction = (player.get_global_mouse_position() - player.global_position).normalized() # Make player face the mouse
			player.animationTree.set("parameters/Attack/BlendSpace2D/blend_position", player.aim_direction)
			player.animationTree.set("parameters/Attack_Combo/BlendSpace2D/blend_position", player.aim_direction)
			player.animationTree.set("parameters/Attack_Combo2/BlendSpace2D/blend_position", player.aim_direction)
		else:
			StateMachine.ChangeState(idle)
