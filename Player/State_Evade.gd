extends State
class_name State_Evade

@onready var idle = $"../Idle"
@onready var run = $"../Run"
@onready var hurt = $"../Hurt"
@export var ROLL_SPEED = 90
var evadeVector = Vector2.DOWN
var evade_complete = false
@onready var evadeShader = preload("res://Player/evade.gdshader")

func Enter():
	player.playerSprite.material.set("shader", evadeShader)
	player.swordSprite.material.set("shader", evadeShader)
	player.animationTree.set("parameters/Dash/BlendSpace2D/blend_position", player.input_vector)	
	hurt.hurtbox.start_invincibility(.6)
	player.UpdateAnimation("Dash")
	AudioManager.get_node("Evade").play()
	
func Exit():
	player.velocity = Vector2.ZERO
	evade_complete = false
	
func Process(_delta : float) -> State:
	return null
	
func Physics(_delta : float) -> State:
	player.velocity = evadeVector * ROLL_SPEED
	player.move_and_slide()
	
	if evade_complete:
		return idle
		
	return null
	
func evade_animation_finished():
	evade_complete = true
