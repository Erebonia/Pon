extends CharacterBody2D

class_name Player

#General (Script)
@onready var stateMachine : PlayerStateMachine = $StateMachine
@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var playerSprite: AnimatedSprite2D = $PlayerSprite

#General (Game)
@onready var stats = Status
@onready var levelUpVFX = $Misc/LevelUp
@onready var checkTime = null
@onready var lightSource = $Misc/Light_Source

#Combat
@onready var baseCombatDMG = $Combat/HitboxPivot/SwordHitbox
@onready var swordSprite = $Combat/Sword/SwordSprite
@onready var swordHitbox = $Combat/HitboxPivot/SwordHitbox
@onready var attackTimer = $Combat/AttackTimer
@onready var healthBar = $Combat_UI/Healthbar

#Debug
@onready var debug = $Misc/debug

#Save System
const save_file_path = "user://save/"
const save_file_name = "Player.tres"
var playerData = PlayerData.new()
var inventory = preload("res://Player/Inventory/PlayerInventory.tres")
var inventoryIsFull: bool

#Directional
var input_vector = Vector2.ZERO
var aim_direction = null

#Changing Werapon Sprites
var weaponEquipped : bool = false
@onready var handSprite: Sprite2D = $Combat/Sword/SwordSprite

func _ready():
	inventory.use_item.connect(use_item)
	inventory.inventory_full.connect(inventoryCheck)
	randomize()
	stateMachine.Initialize(self)
	animationTree.active = true
	stats.connect("no_HP", Callable(self, "playerDead"))
	stats.connect("level_up", Callable(self, "_on_level_up"))
	verifySaveDirectory(save_file_path)
	checkTime = DayAndNight.get_child(1)
	checkTime.connect("time_tick", Callable(self, "_on_check_time"))
	#loadSaveData()
	
func _process(_delta):
	if Input.is_action_just_pressed("Save"):
		saveData()
	if Input.is_action_just_pressed("Load"):
		loadSaveData()
		
	checkSelectedWeapon()	
	updateHealthBarUI()

func _physics_process(_delta):
	setMovementDirection()
		
func UpdateAnimation(state: String):
	animationState.travel(state)
	
func setMovementDirection():
	debug.text = "State: " + stateMachine.current_state.name
	input_vector.x = Input.get_action_strength("Move_Right") - Input.get_action_strength("Move_Left")
	input_vector.y = Input.get_action_strength("Move_Down") - Input.get_action_strength("Move_Up")
	input_vector = input_vector.normalized()
	aim_direction = (get_global_mouse_position() - global_position).normalized() # Make player face the mouse
	move_and_slide()
	
func saveStats():
	#save scene?
	#playerData.loadSavedPosition(self.position)	
	playerData.updateHP(stats.HP)
	playerData.updateMaxHP(stats.max_HP)
	playerData.updateEXP(stats.current_xp)
	playerData.updateLevel(stats.Level)
	playerData.updateDMG(swordHitbox.damage)
	playerData.updateSTR(stats.Strength)
	playerData.updateAGI(stats.Agility)
	playerData.updateMAG(stats.Magic)
	playerData.updateDEF(stats.Defense)
	playerData.updateInventory(inventory.slots)
	playerData.updateDungeonFloor(stats.dungeonFloor)
	
func saveData():
	ResourceSaver.save(playerData, save_file_path + save_file_name)
	print("Game Saved")

func loadSaveData():
	if FileAccess.file_exists(save_file_path + save_file_name):
		playerData = ResourceLoader.load(save_file_path + save_file_name).duplicate(true)
		gameStarted()
		print("Save Loaded")
	else:
		print("File not found. Press O to save!")

signal updateInventoryUI
func gameStarted():
	#Load the data we saved in.
	inventory.slots = playerData.slots
	inventory.check_inventory_full()
	emit_signal("updateInventoryUI")
	#current scene load
	#self.position = playerData.savedPosition
	stats.HP = playerData.HP
	stats.max_HP = playerData.max_HP
	stats.current_xp = playerData.EXP
	stats.Level = playerData.level
	swordHitbox.damage = playerData.damage
	stats.Strength = playerData.strength
	stats.Agility = playerData.agility
	stats.Magic = playerData.magic
	stats.Defense = playerData.defense
	stats.dungeonFloor = playerData.dungeonFloor
	
func verifySaveDirectory(path: String):
	DirAccess.make_dir_absolute(path)
	
func _on_check_time(_day, hour, _minute):
	#24 hour Clock
	if (hour >= 19 and hour <= 23) or (hour >= 0 and hour < 5):
		if scene_manager.currentScene != "Dungeon_1":
			lightSource.visible = true
	else:
		lightSource.visible = false
	
func calculateDmg(dmgBoostStat):
	baseCombatDMG.damage = (Status.Strength * 0.5) + dmgBoostStat
	#baseCombatDMG.damage = dmgBoostStat
		
func _on_level_up(_Level):
	levelUpVFX.play("level_up")
	AudioManager.get_node("Level_Up").play()
	
func updateHealthBarUI():
	healthBar.health = stats.HP
	healthBar.max_value = stats.max_HP
	if healthBar.health == stats.max_HP:
		healthBar.visible = false
			
func _on_area_2d_area_entered(area):
	if area.has_method("collect") and !inventoryIsFull:
		area.collect(inventory)
		
func increase_health(amount: int) -> void:
	stats.HP += amount
	
func use_item(item: InventoryItem) -> void:
	item.use(self)
	
func inventoryCheck(full):
	if full:
		inventoryIsFull = true
	else:
		inventoryIsFull = false

func _on_hp_recovery_timeout():
	if stats.HP < stats.max_HP:
		$Combat/HpRecovery.start()
		stats.HP += 1
		
func checkSelectedWeapon(): 
	var hotbar_instance = get_tree().get_first_node_in_group("Hotbar")
	var currently_selected_index = hotbar_instance.currently_selected
	
	if currently_selected_index < hotbar_instance.inventory.slots.size():
		var inventory_slot = hotbar_instance.inventory.slots[currently_selected_index]
		
		if inventory_slot.item != null:
			#Set the item texture and equip weapon status
			if inventory_slot.item.isWeapon: weaponEquipped = true
			else: weaponEquipped = false
			handSprite.texture = inventory_slot.item.texture
		else:
			handSprite.texture = null
			
func playerDead():
	queue_free()
	
func player():
	pass
	
func _on_save_timeout():
	saveData()
