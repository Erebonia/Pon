extends CharacterBody2D

@onready var player = get_parent().find_child("Player")
@onready var sprite = $Sprite2D
@onready var animationPlayer = $AnimationPlayer
@onready var hurtbox = $Hurtbox
@onready var meleeAttackDir = $FiniteStateMachine/MeleeAttack/MeleeAOE
@onready var bossHealthbar = $UI/BossHealthbar
@onready var healthbar = $Healthbar
@onready var damage_numbers_origin = $DamageNumbersOrigin
@onready var blinkAnimationPlayer = $BlinkAnimationPlayer
@onready var stats = $Stats

var direction : Vector2
@export var ACCELERATION = 30
 
func _ready():
	set_physics_process(false)
	healthbar.max_value = stats.health
	bossHealthbar.max_value = stats.health
	healthbar.init_health(stats.health)  # Corrected function name
	bossHealthbar.init_health(stats.health)

func _process(_delta):
	if direction.x < 0:
		sprite.flip_h = true
		meleeAttackDir.position.x = -31
	else:
		sprite.flip_h = false
		meleeAttackDir.position.x = 17
 
func _physics_process(delta):
	velocity = direction.normalized() * ACCELERATION
	move_and_collide(velocity * delta)
 
func take_damage(area):
	var is_critical = false
	var damage_taken

	if area.damage - stats.DEF > 0:
		damage_taken = (area.damage - stats.DEF)
	else:
		damage_taken = area.damage

	var critical_chance = randf()

	if critical_chance <= 0.10:
		is_critical = true
		var critical_multiplier = randf_range(1.5, 2)
		damage_taken *= critical_multiplier

	stats.health -= damage_taken
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.4)
	DamageNumbers.display_number(damage_taken, damage_numbers_origin.global_position, is_critical)

func _on_hurtbox_area_entered(area):
	if stats.health > 0:
		take_damage(area)
		healthbar.health = stats.health 
		bossHealthbar.health = stats.health 
	if stats.health < 0 and find_child("FiniteStateMachine").current_state != find_child("FiniteStateMachine").find_child("Death"):
		find_child("FiniteStateMachine").change_state("Death")
	elif stats.health <= stats.max_health / 2  and stats.DEF == 0:  # Phase two of the fight he gets tankier
		stats.DEF = 5
		find_child("FiniteStateMachine").change_state("ArmorBuff") 
	#Knockback
	var newDirection = ( position - area.owner.position ).normalized()
	var knockback = newDirection * Status.KNOCKOUT_SPEED
	velocity = knockback
	
func _on_hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")

func _on_hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")
