extends State
class_name State_Roll

@onready var idle = $"../Idle"
@onready var run = $"../Run"

@export var ROLL_SPEED = 90
var roll_vector = Vector2.DOWN

func Enter():
	player.animationTree.set("parameters/Roll/Blendspace2D/blend_position", player.input_vector)	
	player.swordSprite.visible = false
	player.blinkAnimationPlayer.play("Start")
	player.hurtbox.start_invincibility(.6)
	player.UpdateAnimation("Roll")
	
func Exit():
	pass
	
func Process(_delta : float) -> State:
	return null
	
func Physics(_delta : float) -> State:
	roll_vector = player.input_vector
	player.velocity = roll_vector * ROLL_SPEED
	player.move_and_slide()
	
	return null
	
func roll_animation_finished():
	player.blinkAnimationPlayer.play("Stop")
	state_machine.current_state = idle
