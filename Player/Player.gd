extends CharacterBody2D

class_name Player

#General
@onready var state_machine : PlayerStateMachine = $StateMachine
@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")

#Hurtbox
@onready var hurtbox = $Combat/Hurtbox
@onready var blinkAnimationPlayer = $Combat/BlinkAnimationPlayer
@onready var damage_numbers_origin = $Health_UI/DamageNumbersOrigin

#Combat
@onready var swordSprite = $Combat/Sword/SwordSprite
@onready var swordHitbox = $Combat/HitboxPivot/SwordHitbox
@onready var slashFX = $Combat/Sword/SwordSprite/Slash_FX
@onready var attackTimer = $Combat/AttackTimer

#Debug
@onready var debug = $debug

#Directional
var input_vector = Vector2.ZERO
var aim_direction = null

func _ready():
	state_machine.Initialize(self)
	animationTree.active = true
	
func _process(_delta):
	pass
	
func _physics_process(_delta):
	debug.text = "State: " + state_machine.current_state.name
	input_vector.x = Input.get_action_strength("Move_Right") - Input.get_action_strength("Move_Left")
	input_vector.y = Input.get_action_strength("Move_Down") - Input.get_action_strength("Move_Up")
	input_vector = input_vector.normalized()
	aim_direction = (get_global_mouse_position() - global_position).normalized() # Make player face the mouse

	animationTree.set("parameters/Attack/BlendSpace2D/blend_position", aim_direction)
	animationTree.set("parameters/Attack_Combo/BlendSpace2D/blend_position", aim_direction)
	animationTree.set("parameters/Attack_Combo2/BlendSpace2D/blend_position", aim_direction)
	move_and_slide()
		
func UpdateAnimation(state: String):
	animationState.travel(state)

func calculateDmg(dmgBoostStat):
	swordHitbox.damage = dmgBoostStat
	
func player():
	pass

