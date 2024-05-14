extends State
class_name State_Sword_Stance

@onready var run = $"../Run"
@onready var evade = $"../Evade"
@onready var idle = $"../Idle"

#Sword Stance
@onready var sword_wave_projectile = $"../../Combat/SwordWaveProjectile"
@onready var sword_wave_cooldown = $"../../Combat/SwordWaveProjectile/swordWaveCooldown"
@onready var sword_stance_aura_fx = $"../../Combat/SwordStance_ActivateAura"
@onready var sword_stance_animation = $"../../Combat/Sword/SwordSprite/SwordWave_FX"
@onready var sword_stance_label = $"../../Combat/SwordStance_ActivateAura/SwordStanceLabel"
@onready var sword_glow = $"../../Combat/Sword/SwordSprite/SwordStance_Glowing"

var sword_wave_slash = preload("res://Player/swordWaveProjectile.tscn")
var performing_sword_wave = false
var last_animation = "attack_combo1"  # Initialize to the first animation
var stance_ended: bool = false

func Enter():
	#Activate Special FX
	sword_stance_label.visible = true
	sword_stance_aura_fx.play("aura")
	sword_glow.visible = true
	sword_glow.play("glow")
	sword_stance_animation.play("enter_sword_stance")

	#Enter Actual Stance
	player.animation_tree.set_active(false)
	player.animation_player.play("swordStance")
	AudioManager.get_node("Swordwave_Stance").play()
	await player.animation_player.animation_finished
	player.animation_tree.set_active(true)
	
	#Stat Bonus
	run.MAX_SPEED = 120
	player.player_data.KNOCKOUT_SPEED = 30
	player.animation_tree.set("parameters/Attack_Combo/TimeScale/scale", 5)
	player.animation_tree.set("parameters/Attack_Combo2/TimeScale/scale", 5)
	sword_wave_cooldown.start()
	stance_ended = true
	
func Exit():
	sword_glow.stop()
	sword_glow.visible = false
	sword_stance_label.visible = false
	run.MAX_SPEED = 80
	player.player_data.KNOCKOUT_SPEED = 0
	player.animation_tree.set("parameters/Attack_Combo/TimeScale/scale", 2)
	player.animation_tree.set("parameters/Attack_Combo2/TimeScale/scale", 2)
	
func Process(_delta : float) -> State:
	return null
	
func Physics(delta : float) -> State:
	if Input.is_action_pressed("attack") and player.weapon_equipped and stance_ended:
		player.velocity = Vector2.ZERO
		activateStance()
	elif !performing_sword_wave and stance_ended:
		swordStanceMoveState(delta)
	
	return null
	
func activateStance():
	if !performing_sword_wave:
		performing_sword_wave = true
		# Set the rotation of the sword wave projectile to match the character's facing direction
		var aim_direction = (player.get_global_mouse_position() - player.global_position).normalized() # Make player face the mouse
		sword_wave_projectile.rotation = atan2(aim_direction.y, aim_direction.x)
		toggle_attack_animation()
		await player.animation_tree.animation_finished
		var sword_wave_instance = sword_wave_slash.instantiate()
		sword_wave_instance.rotation = sword_wave_projectile.rotation
		sword_wave_instance.global_position = sword_wave_projectile.global_position
		AudioManager.get_node("Swordwave_Projectile").play()
		add_child(sword_wave_instance)
		# Cooldown
		await get_tree().create_timer(0.2).timeout
		performing_sword_wave = false
		
func toggle_attack_animation():
	if last_animation == "Attack_Combo":
		player.animation_tree.set("parameters/Attack_Combo2/BlendSpace2D/blend_position", player.aim_direction)
		player.UpdateAnimation("Attack_Combo2")
		last_animation = "Attack_Combo2"
	else:
		player.animation_tree.set("parameters/Attack_Combo/BlendSpace2D/blend_position", player.aim_direction)
		player.UpdateAnimation("Attack_Combo")
		last_animation = "Attack_Combo"

func _on_sword_wave_cooldown_timeout():
	performing_sword_wave = false
	state_machine.ChangeState(idle)
	print("Sword Wave is now on cooldown")
	
func swordStanceMoveState(delta):
		if player.input_vector != Vector2.ZERO: 
			player.UpdateAnimation("Run")
			evade.evade_vector = player.input_vector
			player.velocity = player.velocity.move_toward(player.input_vector * run.MAX_SPEED, run.ACCELERATION * delta) # This will be the direction we move to
			player.animation_tree.set("parameters/Run/blend_position", player.input_vector)
			player.animation_tree.set("parameters/Idle/blend_position", player.input_vector)
			player.animation_tree.set("parameters/Attack_Combo/BlendSpace2D/blend_position", player.aim_direction)
			player.animation_tree.set("parameters/Attack_Combo2/BlendSpace2D/blend_position", player.aim_direction)
			player.aim_direction = (player.get_global_mouse_position() - player.global_position).normalized() # Make player face the mouse
		else:
			player.velocity = Vector2.ZERO
			player.UpdateAnimation("Idle")	
			
