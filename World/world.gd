extends Node2D

@onready var camera = $World_Camera
@onready var clouds = $World_Camera/Cloud
@onready var raylights = $World_Camera/Raylight
@onready var leaves = $World_Camera/Leaf
@onready var rain = $World_Camera/Rain

var checkTime = DayAndNight.get_child(1)
var savedHour: int

func _ready():
	checkTime.connect("time_tick", Callable(self, "_on_check_time"))

func _on_check_time(_day, hour, _minute):
	#Randomize Weather
	if savedHour < hour:
		print("RANDOM WEATHER ACTIVE")
		randomWeather()
		savedHour = hour
		
	#Night Time
	if (hour >= 19 and hour <= 23) or (hour >= 0 and hour < 6):
		clouds.emitting = false 
		raylights.emitting = false
		leaves.emitting = false
	else:
		clouds.emitting = true 
		raylights.emitting = true

func randomWeather():
	var randomPick = randi_range(1,2)
	print(randomPick)
	match randomPick:
		1:
			leaves.emitting = true
			rain.emitting = false
		2:
			leaves.emitting = false
			rain.emitting = true

func _on_inventory_gui_opened():
	get_tree().paused = true

func _on_inventory_gui_closed():
	get_tree().paused = false

