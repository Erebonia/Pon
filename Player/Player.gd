extends CharacterBody2D

class_name Player

#General (Script)
@onready var state_machine : PlayerStateMachine = $StateMachine
@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")

#General (Game)
@onready var checkTime = null
@onready var light_source = $Misc/Light_Source

#Hurtbox
@onready var hurtbox = $Combat/Hurtbox
@onready var blinkAnimationPlayer = $Combat/BlinkAnimationPlayer
@onready var damage_numbers_origin = $Health_UI/DamageNumbersOrigin

#Combat (General)
@onready var stats = Status
@onready var healthBar = $Healthbar

#Combat (Attacks)
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
	stats.connect("no_HP", Callable(self, "playerDead"))
	stats.connect("level_up", Callable(self, "_on_level_up"))
	animationTree.active = true
	healthBar.max_value = stats.max_HP
	healthBar.init_health(stats.HP)
	if checkTime != null:
		checkTime = get_parent().find_child("DayNightCycle").get_child(1)
	
func _process(_delta):
	pass
	
func _physics_process(_delta):
	
	if Input.is_action_just_pressed("Status"):
		stats.visible = not stats.visible
		
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
	
func _on_check_time(_day, hour, _minute):
	#military time
	if (hour >= 19 and hour <= 23) or (hour >= 0 and hour < 5):
		light_source.visible = true
	else:
		light_source.visible = false
	
func player():
	pass

