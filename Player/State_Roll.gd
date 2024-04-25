extends State
class_name State_Roll

@onready var idle = $"../Idle"
@onready var run = $"../Run"
@onready var hurt = $"../Hurt"

@export var ROLL_SPEED = 90
var rollVector = Vector2.DOWN

func Enter():
	player.animationTree.set("parameters/Roll/Blendspace2D/blend_position", player.input_vector)	
	hurt.blinkAnimationPlayer.play("Start")
	hurt.hurtbox.start_invincibility(.6)
	player.UpdateAnimation("Roll")
	
func Exit():
	player.velocity = Vector2.ZERO
	
func Process(_delta : float) -> State:
	return null
	
func Physics(_delta : float) -> State:
	player.velocity = rollVector * ROLL_SPEED
	player.move_and_slide()
	
	return null
	
func roll_animation_finished():
	hurt.blinkAnimationPlayer.play("Stop")
	StateMachine.ChangeState(idle)
