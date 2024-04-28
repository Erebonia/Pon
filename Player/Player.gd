extends CharacterBody2D

class_name Player

#General (Script)
@onready var stateMachine : PlayerStateMachine = $StateMachine
@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")

#General (Game)
@onready var stats = Status
@onready var levelUpSound = $Misc/LevelUp
@onready var checkTime = null
@onready var lightSource = $Misc/Light_Source

#Combat
@onready var baseCombatDMG = $Combat/HitboxPivot/SwordHitbox
@onready var swordSprite = $Combat/Sword/SwordSprite
@onready var swordHitbox = $Combat/HitboxPivot/SwordHitbox
@onready var slashFX = $Combat/Sword/SwordSprite/Slash_FX
@onready var attackTimer = $Combat/AttackTimer
@onready var healthBar = $Combat_UI/Healthbar

#Debug
@onready var debug = $debug

#Save System
const save_file_path = "user://save/"
const save_file_name = "Player.tres"
var playerData = PlayerData.new()

#Directional
var input_vector = Vector2.ZERO
var aim_direction = null

func _ready():
	randomize()
	stateMachine.Initialize(self)
	animationTree.active = true
	stats.connect("no_HP", Callable(self, "playerDead"))
	stats.connect("level_up", Callable(self, "_on_level_up"))
	verifySaveDirectory(save_file_path)
	checkTime = DayAndNight.get_child(1)
	checkTime.connect("time_tick", Callable(self, "_on_check_time"))
	
func _process(_delta):
	if Input.is_action_just_pressed("Save"):
		saveData()
	if Input.is_action_just_pressed("Load"):
		loadSaveData()
	#Extract and save these.
	playerData.loadSavedPosition(self.position)	
	playerData.updateHP(Status.HP)
	playerData.updateMaxHP(Status.max_HP)
	playerData.updateEXP(Status.current_xp)
	playerData.updateLevel(Status.Level)
	playerData.updateDMG(swordHitbox.damage)
	playerData.updateSTR(Status.Strength)
	playerData.updateAGI(Status.Agility)
	playerData.updateMAG(Status.Magic)
	playerData.updateDEF(Status.Defense)
	
	updateHealthBarUI()

func _physics_process(_delta):
	if Input.is_action_just_pressed("Status"):
		stats.visible = not stats.visible
		
	setMovementDirection()
		
func UpdateAnimation(state: String):
	animationState.travel(state)
	
func setMovementDirection():
	debug.text = "State: " + stateMachine.current_state.name
	input_vector.x = Input.get_action_strength("Move_Right") - Input.get_action_strength("Move_Left")
	input_vector.y = Input.get_action_strength("Move_Down") - Input.get_action_strength("Move_Up")
	input_vector = input_vector.normalized()
	move_and_slide()

func calculateDmg(dmgBoostStat):
	baseCombatDMG.damage = dmgBoostStat
	
func _on_check_time(_day, hour, _minute):
	#24 hour Clock
	if (hour >= 19 and hour <= 23) or (hour >= 0 and hour < 5):
		lightSource.visible = true
	else:
		lightSource.visible = false
		
func _on_level_up():
	levelUpSound.play("level_up")
	
func playerDead():
	queue_free()
	
func player():
	pass
	
func saveData():
	ResourceSaver.save(playerData, save_file_path + save_file_name)
	print("Game Saved")

signal gameLoaded
func loadSaveData():
	playerData = ResourceLoader.load(save_file_path + save_file_name).duplicate(true)
	gameStarted()
	print("Save Loaded")

func gameStarted():
	#Load the data we saved in.
	self.position = playerData.savedPosition
	stats.HP = playerData.HP
	stats.max_HP = playerData.max_HP
	stats.current_xp = playerData.EXP
	stats.Level = playerData.level
	swordHitbox.damage = playerData.damage
	stats.Strength = playerData.strength
	stats.Agility = playerData.agility
	stats.Magic = playerData.magic
	stats.Defense = playerData.defense
	
func verifySaveDirectory(path: String):
	DirAccess.make_dir_absolute(path)
	
func updateHealthBarUI():
	healthBar.health = stats.HP
	healthBar.max_value = stats.max_HP
	if healthBar.health == stats.max_HP:
		healthBar.visible = false
			
