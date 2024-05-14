extends State
class_name State_Hurt

@onready var inventory: Inventory = preload("res://Player/Inventory/PlayerInventory.tres")

#Hurtbox
@onready var hurtbox = $"../../Combat/Hurtbox"
@onready var blink_animation_player = $"../../Combat/BlinkAnimationPlayer"
@onready var damage_numbers_origin = $"../../Combat_UI/DamageNumbersOrigin"
@onready var health_bar = $"../../Combat_UI/Healthbar"

# States
@onready var hurt = $"../Hurt"
@onready var idle = $"../Idle"
@onready var evade = $"../Evade"

@onready var default_shader = preload("res://Player/WhiteColor.gdshader")

func Enter():
	health_bar.max_value = player.player_data.max_HP
	health_bar.init_health(player.player_data.HP)
	
func Exit():
	player.player_data.disconnect("no_HP", Callable(self, "playerDead"))
	
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
		player.player_data.HP -= area.damage * critical_multiplier # Apply critical damage
		DamageNumbers.display_number(area.damage * critical_multiplier, damage_numbers_origin.global_position, is_critical)
	else:
		player.player_data.HP -= area.damage
		DamageNumbers.display_number(area.damage, damage_numbers_origin.global_position, is_critical)
	
	health_bar.health = player.player_data.HP
	health_bar.max_value = player.player_data.max_HP
	
	if player.player_data.HP < player.player_data.max_HP:
		health_bar.visible = true
		
func _on_hurtbox_area_entered(area):
	takeDamage(area)
	
	if area.has_method("projectile"):
		area.queue_free()
	
	#Invincibility and hit effect    
	hurtbox.start_invincibility(.6)

	#Hurtbox Sound
	AudioManager.get_node("Hurt").play()
		
func _on_hurtbox_invincibility_started():
	if state_machine.current_state == evade:
		blink_animation_player.play("Evade")
	else:
		blink_animation_player.play("Start")

func _on_hurtbox_invincibility_ended():
	player.player_sprite.material.set("shader", default_shader)
	player.sword_sprite.material.set("shader", default_shader)
	blink_animation_player.play("Stop")
