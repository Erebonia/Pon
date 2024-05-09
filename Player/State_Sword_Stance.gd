extends State
class_name State_Sword_Stance

@onready var run = $"../Run"
@onready var roll = $"../Roll"
@onready var idle = $"../Idle"

#Sword Stance
@onready var swordWaveProjectile = $"../../Combat/SwordWaveProjectile"
@onready var swordWaveCooldown = $"../../Combat/SwordWaveProjectile/swordWaveCooldown"
@onready var swordStanceAuraFX = $"../../Combat/SwordStance_ActivateAura"
@onready var swordStanceAnimation = $"../../Combat/Sword/SwordSprite/SwordWave_FX"
@onready var swordStanceLabel = $"../../Combat/SwordStance_ActivateAura/SwordStanceLabel"
@onready var swordGlow = $"../../Combat/Sword/SwordSprite/SwordStance_Glowing"

var swordWaveSlash = preload("res://Player/swordWaveProjectile.tscn")
var isPerformingSwordWave = false
var lastAnimationPlayed = "attack_combo1"  # Initialize to the first animation
var stanceEnded: bool = false

func Enter():
	#Activate Special FX
	swordStanceLabel.visible = true
	swordStanceAuraFX.play("aura")
	swordGlow.visible = true
	swordGlow.play("glow")
	swordStanceAnimation.play("enter_sword_stance")

	#Enter Actual Stance
	player.animationTree.set_active(false)
	player.animationPlayer.play("swordStance")
	AudioManager.get_node("Swordwave_Stance").play()
	await player.animationPlayer.animation_finished
	player.animationTree.set_active(true)
	swordStanceAuraFX.play("default")
	
	#Stat Bonus
	run.MAX_SPEED = 120
	Status.KNOCKOUT_SPEED = 30
	player.animationTree.set("parameters/Attack_Combo/TimeScale/scale", 5)
	player.animationTree.set("parameters/Attack_Combo2/TimeScale/scale", 5)
	swordWaveCooldown.start()
	stanceEnded = true
	
func Exit():
	swordGlow.stop()
	swordGlow.visible = false
	swordStanceLabel.visible = false
	run.MAX_SPEED = 80
	Status.KNOCKOUT_SPEED = 0
	player.animationTree.set("parameters/Attack_Combo/TimeScale/scale", 2)
	player.animationTree.set("parameters/Attack_Combo2/TimeScale/scale", 2)
	
func Process(_delta : float) -> State:
	return null
	
func Physics(delta : float) -> State:
	if Input.is_action_pressed("attack") and player.weaponEquipped and stanceEnded:
		player.velocity = Vector2.ZERO
		activateStance()
	elif !isPerformingSwordWave and stanceEnded:
		swordStanceMoveState(delta)
	
	return null
	
func activateStance():
	if !isPerformingSwordWave:
		isPerformingSwordWave = true
		# Set the rotation of the sword wave projectile to match the character's facing direction
		var aim_direction = (player.get_global_mouse_position() - player.global_position).normalized() # Make player face the mouse
		swordWaveProjectile.rotation = atan2(aim_direction.y, aim_direction.x)
		toggle_attack_animation()
		await player.animationTree.animation_finished
		var sword_wave_instance = swordWaveSlash.instantiate()
		sword_wave_instance.rotation = swordWaveProjectile.rotation
		sword_wave_instance.global_position = swordWaveProjectile.global_position
		AudioManager.get_node("Swordwave_Projectile").play()
		add_child(sword_wave_instance)
		# Cooldown
		await get_tree().create_timer(0.2).timeout
		isPerformingSwordWave = false
		
func toggle_attack_animation():
	if lastAnimationPlayed == "Attack_Combo":
		player.animationTree.set("parameters/Attack_Combo2/BlendSpace2D/blend_position", player.aim_direction)
		player.UpdateAnimation("Attack_Combo2")
		lastAnimationPlayed = "Attack_Combo2"
	else:
		player.animationTree.set("parameters/Attack_Combo/BlendSpace2D/blend_position", player.aim_direction)
		player.UpdateAnimation("Attack_Combo")
		lastAnimationPlayed = "Attack_Combo"

func _on_sword_wave_cooldown_timeout():
	isPerformingSwordWave = false
	StateMachine.ChangeState(idle)
	print("Sword Wave is now on cooldown")
	
func swordStanceMoveState(delta):
		if player.input_vector != Vector2.ZERO: 
			player.UpdateAnimation("Run")
			roll.rollVector = player.input_vector
			player.velocity = player.velocity.move_toward(player.input_vector * run.MAX_SPEED, run.ACCELERATION * delta) # This will be the direction we move to
			player.animationTree.set("parameters/Run/blend_position", player.input_vector)
			player.animationTree.set("parameters/Idle/blend_position", player.input_vector)
			player.animationTree.set("parameters/Attack_Combo/BlendSpace2D/blend_position", player.aim_direction)
			player.animationTree.set("parameters/Attack_Combo2/BlendSpace2D/blend_position", player.aim_direction)
			player.aim_direction = (player.get_global_mouse_position() - player.global_position).normalized() # Make player face the mouse
		else:
			player.velocity = Vector2.ZERO
			player.UpdateAnimation("Idle")	
			
