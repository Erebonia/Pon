extends State
class_name State_Evade

@onready var idle : Node2D = $"../Idle"
@onready var run : Node2D = $"../Run"
@onready var hurt : Node2D = $"../Hurt"
@export var ROLL_SPEED : int = 90
var evade_vector : Vector2 = Vector2.DOWN
var evade_complete : bool = false
@onready var evade_shader = preload("res://Player/evade.gdshader")

func Enter():
	player.player_sprite.material.set("shader", evade_shader)
	player.sword_sprite.material.set("shader", evade_shader)
	player.animation_tree.set("parameters/Dash/BlendSpace2D/blend_position", player.input_vector)	
	hurt.hurtbox.start_invincibility(.6)
	player.UpdateAnimation("Dash")
	AudioManager.get_node("Evade").play()
	
func Exit():
	player.velocity = Vector2.ZERO
	evade_complete = false
	
func Process(_delta : float) -> State:
	return null
	
func Physics(_delta : float) -> State:
	player.velocity = evade_vector * ROLL_SPEED
	player.move_and_slide()
	
	if evade_complete:
		return idle
		
	return null
	
func evade_animation_finished():
	evade_complete = true
