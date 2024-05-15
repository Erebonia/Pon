extends CharacterBody2D

class_name Player

#General (Script)
@onready var state_machine : PlayerStateMachine = $StateMachine
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var player_sprite: AnimatedSprite2D = $PlayerSprite

#General (Game)
@onready var level_up_vfx : AnimatedSprite2D = $Misc/LevelUp
@onready var check_time = null
@onready var light_source : PointLight2D = $Misc/Light_Source

#Combat
@onready var sword_sprite : Sprite2D = $Combat/Sword/SwordSprite
@onready var sword_hitbox : Node2D = $Combat/HitboxPivot/SwordHitbox
@onready var attack_timer : Timer = $Combat/AttackTimer
@onready var health_bar : ProgressBar = $Combat_UI/Healthbar

#Debug
@onready var debug = $Misc/debug

#Save System
const save_file_path = "user://save/"
const save_file_name = "Player.tres"
var player_data = PlayerData.new()
var inventory = preload("res://Player/Inventory/PlayerInventory.tres")
var inventory_full: bool

#Directional
var input_vector : Vector2 = Vector2.ZERO
var aim_direction : Vector2 

#Changing Weapon Sprites
var weapon_equipped : bool = false
@onready var hand_sprite: Sprite2D = $Combat/Sword/SwordSprite

func _ready():
	verifySaveDirectory(save_file_path)
	#loadSaveData()
	randomize()
	state_machine.Initialize(self)
	inventory.use_item.connect(use_item)
	inventory.inventory_full.connect(inventoryCheck)
	check_time = DayAndNight.get_child(1)
	check_time.connect("time_tick", Callable(self, "_on_check_time"))
	animation_tree.active = true
	
func _process(_delta):
	if Input.is_action_just_pressed("Save"):
		savePlayerData()
		saveDataToFile()
	if Input.is_action_just_pressed("Load"):
		loadSaveData()
		
	checkSelectedWeapon()	
	updateHealthBarUI()

func _physics_process(_delta):
	setMovementDirection()
		
func UpdateAnimation(state: String):
	animation_state.travel(state)
	
func setMovementDirection():
	debug.text = "State: " + state_machine.current_state.name
	input_vector.x = Input.get_action_strength("Move_Right") - Input.get_action_strength("Move_Left")
	input_vector.y = Input.get_action_strength("Move_Down") - Input.get_action_strength("Move_Up")
	input_vector = input_vector.normalized()
	aim_direction = (get_global_mouse_position() - global_position).normalized() # Make player face the mouse
	move_and_slide()
	
func savePlayerData():
	#Save Scene and Location
	#player_data.loadSavedPosition(self.position)	
	player_data.updateInventory(inventory.slots)
	player_data.updateBaseDMG(sword_hitbox.damage)
	
func saveDataToFile():
	var save_path = save_file_path + save_file_name
	verifySaveDirectory(save_path)
	print("Saving to: ", save_path)
	ResourceSaver.save(player_data, save_path)

func loadSaveData():
	if FileAccess.file_exists(save_file_path + save_file_name):
		player_data = ResourceLoader.load(save_file_path + save_file_name).duplicate(true)
		gameStarted()
		print("Save Loaded")
	else:
		print("File not found. Press O to save!")

signal updateInventoryUI
func gameStarted():
	#Load the data we saved in.
	inventory.slots = player_data.slots
	inventory.check_inventory_full()
	emit_signal("updateInventoryUI")
	sword_hitbox.damage = player_data.base_damage
	
	#Reload the last scene and position
	#self.position = player_data.savedPosition
	
func verifySaveDirectory(path: String):
	DirAccess.make_dir_absolute(path)
	
func _on_check_time(_day, hour, _minute):
	#24 hour Clock
	if (hour >= 19 and hour <= 23) or (hour >= 0 and hour < 5):
		if scene_manager.current_scene != "Dungeon_1":
			light_source.visible = true
	else:
		light_source.visible = false
	
func calculateDmg(dmgBoostStat):
	sword_hitbox.damage = (player_data.Strength * 0.5) + dmgBoostStat
		
func _on_level_up():
	level_up_vfx.play("level_up")
	AudioManager.get_node("Level_Up").play()
	
func updateHealthBarUI():
	health_bar.health = player_data.HP
	health_bar.max_value = player_data.max_HP
	if health_bar.health == player_data.max_HP:
		health_bar.visible = false
			
func _on_area_2d_area_entered(area):
	if area.has_method("collect") and !inventory_full:
		area.collect(inventory)
		
func increase_health(amount: int) -> void:
	player_data.HP += amount
	
func use_item(item: InventoryItem) -> void:
	item.use(self)
	
func inventoryCheck(full):
	if full:
		inventory_full = true
	else:
		inventory_full = false

func _on_hp_recovery_timeout():
	if player_data.HP < player_data.max_HP:
		$Combat/HpRecovery.start()
		player_data.HP += 1
		
func checkSelectedWeapon(): 
	var hotbar_instance = get_tree().get_first_node_in_group("Hotbar")
	var currently_selected_index = hotbar_instance.currently_selected
	
	if currently_selected_index < hotbar_instance.inventory.slots.size():
		var inventory_slot = hotbar_instance.inventory.slots[currently_selected_index]
		
		if inventory_slot.item != null:
			#Set the item texture and equip weapon status
			if inventory_slot.item.isWeapon: weapon_equipped = true
			else: weapon_equipped = false
			hand_sprite.texture = inventory_slot.item.texture
		else:
			hand_sprite.texture = null
			
func playerDead():
	queue_free()
	
func _on_save_timeout():
	savePlayerData()
	saveDataToFile()
