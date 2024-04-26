extends CharacterBody2D

class_name Player

#General (Script)
@onready var stateMachine : PlayerStateMachine = $StateMachine
@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")

#General (Game)
@onready var stats = Status
@onready var levelUpSound = $Misc/LevelUp
@onready var checkTime = null
@onready var lightSource = $Misc/Light_Source

#Combat
@onready var baseCombatDMG = $Combat/HitboxPivot/SwordHitbox
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
	randomize()
	stateMachine.Initialize(self)
	animationTree.active = true
	stats.connect("no_HP", Callable(self, "playerDead"))
	stats.connect("level_up", Callable(self, "_on_level_up"))
	
	if checkTime != null:
		checkTime = get_parent().find_child("DayNightCycle").get_child(1)
	
func _process(_delta):
	pass
	
func _physics_process(_delta):
	
	if Input.is_action_just_pressed("Status"):
		stats.visible = not stats.visible
		
	setMovementDirection()
		
func UpdateAnimation(state: String):
	animationState.travel(state)
	
func setMovementDirection():
	debug.text = "State: " + stateMachine.current_state.name
	input_vector.x = Input.get_action_strength("Move_Right") - Input.get_action_strength("Move_Left")
	input_vector.y = Input.get_action_strength("Move_Down") - Input.get_action_strength("Move_Up")
	input_vector = input_vector.normalized()
	move_and_slide()

func calculateDmg(dmgBoostStat):
	baseCombatDMG.damage = dmgBoostStat
	
func _on_check_time(_day, hour, _minute):
	#military time
	if (hour >= 19 and hour <= 23) or (hour >= 0 and hour < 5):
		lightSource.visible = true
	else:
		lightSource.visible = false
		
func _on_level_up():
	levelUpSound.play("level_up")
	
func playerDead():
	queue_free()
	
func player():
	pass
	
		


