extends State
class_name State_Hurt

#Hurtbox
@onready var hurtbox = $"../../Combat/Hurtbox"
@onready var blinkAnimationPlayer = $"../../Combat/BlinkAnimationPlayer"
@onready var damage_numbers_origin = $"../../Health_UI/DamageNumbersOrigin"
@onready var healthBar = $"../../Healthbar"
@onready var stats = Status

# States
@onready var hurt = $"../Hurt"
@onready var idle = $"../Idle"

const PlayerHurtSound = preload("res://Player/player_hurt_sound.tscn")

func Enter():
	stats.connect("no_HP", Callable(self, "playerDead"))
	stats.connect("level_up", Callable(self, "_on_level_up"))
	healthBar.max_value = stats.max_HP
	healthBar.init_health(stats.HP)
	
func Exit():
	pass
	
func Process(_delta : float) -> State:
	return null
	
func Physics(_delta : float) -> State: 
	#Stop Movement
	player.velocity = Vector2.ZERO
	return null
	
func takeDamage(area):
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
	
	if player.stats.HP < stats.max_HP:
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
