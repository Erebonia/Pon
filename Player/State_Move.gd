extends State
class_name State_Move

#Speed
@export var ACCELERATION = 500
@export var MAX_SPEED = 80
@export var ROLL_SPEED = 80
@export var Friction = 500

@onready var idle : State = $"../Idle"
@onready var evade : State = $"../Evade"
@onready var attack = $"../Attack"

func Enter():
	player.UpdateAnimation("Run")
	if scene_manager.currentScene == "World":
		AudioManager.get_node("Footsteps_Grass").play()
	elif scene_manager.currentScene == "Dungeon_1":
		AudioManager.get_node("Footsteps_Stone").play()
	
func Exit():
	AudioManager.get_node("Footsteps_Grass").stop()
	AudioManager.get_node("Footsteps_Stone").stop()
	
func Process(_delta : float) -> State:
	return null
	
func Physics(delta : float) -> State:
	
	if Input.is_action_just_pressed("evade"):
		return evade
	
	if Input.is_action_pressed("attack") and player.weaponEquipped:
		return attack
		
	move_state(delta)
	
	return null
	
func move_state(delta):
		if player.input_vector != Vector2.ZERO: 
			evade.evadeVector = player.input_vector
			player.velocity = player.velocity.move_toward(player.input_vector * MAX_SPEED, ACCELERATION * delta) # This will be the direction we move to
			player.animationTree.set("parameters/Run/blend_position", player.input_vector)
			player.animationTree.set("parameters/Idle/blend_position", player.input_vector)
		else:
			StateMachine.ChangeState(idle)
