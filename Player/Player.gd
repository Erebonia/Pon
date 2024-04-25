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
const PlayerHurtSound = preload("res://Player/player_hurt_sound.tscn")

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
	
func takeDamage(area): #TODO make a hurt state later.
	var is_critical = false
	var critical_chance = randf()

	if critical_chance <= 0.1:
		is_critical = true
		var critical_multiplier = randf_range(1.2, 2) # Crit chance between these values
		stats.HP -= area.damage * critical_multiplier # Apply critical damage
		DamageNumbers.display_number(area.damage * critical_multiplier, damage_numbers_origin.global_position, is_critical)
	else:
		stats.HP -= area.damage
		DamageNumbers.display_number(area.damage, damage_numbers_origin.global_position, is_critical)
	
	healthBar.health = stats.HP
	
	if stats.HP < stats.max_HP:
		healthBar.visible = true
		
func _on_hurtbox_area_entered(area):
	takeDamage(area)
	
	if area.has_method("projectile"):
		area.queue_free()
	
	#Invincibility and hit effect    
	hurtbox.start_invincibility(.6)
	hurtbox.create_hit_effect()

	#Hurtbox Sound
	var playerHurtSound = PlayerHurtSound.instantiate()
	get_tree().current_scene.add_child(playerHurtSound)
		
func _on_hurtbox_invincibility_started():
		blinkAnimationPlayer.play("Start")

func _on_hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")

