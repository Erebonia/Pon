extends CharacterBody2D

const EnemyDeathEffect = preload("res://Effects/enemy_death_effect.tscn")

#Speed 
@export var ACCELERATION = 300
@export var MAX_SPEED = 50
@export var FRICTION = 200

#Combat
@onready var stats = $Stats
@export var WANDER_TARGET_RANGE = 4
@onready var hurtbox = $Hurtbox
@onready var healthBar = $Healthbar
@onready var damage_numbers_origin = $DamageNumbersOrigin

#General
@onready var softCollision = $SoftCollision
@onready var animationPlayer = $AnimationPlayer
@onready var sprite = $AnimatedSprite
@onready var playerDetectionZone = $PlayerDetection
@onready var startPosition = get_global_transform().origin
@onready var wanderController = $WanderController

enum {
	IDLE,
	WANDER,
	CHASE,
}

var state = CHASE

func _ready():
	state = pick_random_state([IDLE, WANDER])
	healthBar.max_value = stats.max_health
	healthBar.init_health(stats.health)

func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()
		
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
			accelerate_towards_point(wanderController.target_position, delta)
			if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
				update_wander()
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
			else:
				state = IDLE
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	move_and_slide()
	
func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(randf_range(1,3))
		
func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0		
	
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
			
func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
	
func _on_hurtbox_area_entered(area):
	var is_critical = false
	var damage_taken
	
	hurtbox.start_invincibility(.4)
	hurtbox.create_hit_effect()

	if area.damage - stats.DEF > 0:
		damage_taken = (area.damage - stats.DEF)
	else:
		damage_taken = area.damage

	var critical_chance = randf()

	if critical_chance <= 0.10:
		is_critical = true
		var critical_multiplier = randf_range(1.2, 2)
		damage_taken *= critical_multiplier
		
	stats.health -= damage_taken
	DamageNumbers.display_number(damage_taken, damage_numbers_origin.global_position, is_critical)
	#Update Healthbar
	healthBar.health = stats.health
	
	#Knockback
	var direction = ( position - area.owner.position ).normalized()
	var knockback = direction * Status.KNOCKOUT_SPEED
	velocity = knockback
	
	#Display visible Healthbar
	if stats.health < stats.max_health:
		healthBar.visible = true
	
func _on_stats_no_health():
	queue_free()
	#Puts the death effect where the enemy died.
	var enemyDeathEffect = EnemyDeathEffect.instantiate()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position

func _on_hurtbox_invincibility_started():
	animationPlayer.play("Start")

func _on_hurtbox_invincibility_ended():
	animationPlayer.play("Stop")
	
