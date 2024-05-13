extends State
class_name State_Hurt

@onready var inventory: Inventory = preload("res://Player/Inventory/PlayerInventory.tres")

#Hurtbox
@onready var hurtbox = $"../../Combat/Hurtbox"
@onready var blinkAnimationPlayer = $"../../Combat/BlinkAnimationPlayer"
@onready var damageNumbersOrigin = $"../../Combat_UI/DamageNumbersOrigin"
@onready var healthBar = $"../../Combat_UI/Healthbar"
@onready var stats = Status

# States
@onready var hurt = $"../Hurt"
@onready var idle = $"../Idle"
@onready var evade = $"../Evade"

@onready var defaultShader = preload("res://Player/WhiteColor.gdshader")

func Enter():
	healthBar.max_value = stats.max_HP
	healthBar.init_health(stats.HP)
	
func Exit():
	stats.disconnect("no_HP", Callable(self, "playerDead"))
	
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
		DamageNumbers.display_number(area.damage * critical_multiplier, damageNumbersOrigin.global_position, is_critical)
	else:
		stats.HP -= area.damage
		DamageNumbers.display_number(area.damage, damageNumbersOrigin.global_position, is_critical)
	
	healthBar.health = stats.HP
	healthBar.max_value = stats.max_HP
	
	if stats.HP < stats.max_HP:
		healthBar.visible = true
		
func _on_hurtbox_area_entered(area):
	takeDamage(area)
	
	if area.has_method("projectile"):
		area.queue_free()
	
	#Invincibility and hit effect    
	hurtbox.start_invincibility(.6)

	#Hurtbox Sound
	AudioManager.get_node("Hurt").play()
		
func _on_hurtbox_invincibility_started():
	if StateMachine.current_state == evade:
		blinkAnimationPlayer.play("Evade")
	else:
		blinkAnimationPlayer.play("Start")

func _on_hurtbox_invincibility_ended():
	player.playerSprite.material.set("shader", defaultShader)
	blinkAnimationPlayer.play("Stop")
