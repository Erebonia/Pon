extends BaseScene

@onready var camera = $World_Camera
@onready var clouds = $World_Camera/Cloud
@onready var raylights = $World_Camera/Raylight
@onready var leaves = $World_Camera/Leaf
@onready var rain = $World_Camera/Rain
@onready var fog = $Environment/FogShader

var checkTime = DayAndNight.get_child(1)
var savedDay: int
var savedHour: int

func _ready():
	super()
	checkTime.connect("time_tick", Callable(self, "_on_check_time"))

func _on_check_time(day, hour, _minute):
	# Randomize Weather every 12 hours
	if savedHour == -1 or hour == (savedHour + 12) % 24:
		#print("Hour: " + str(hour))
		randomWeather()
		savedHour = hour
	
	# Update savedDay at midnight
	if savedDay != day:
		savedDay = day
		
	#Night Time
	if (hour >= 19 and hour <= 23) or (hour >= 0 and hour < 6):
		clouds.emitting = false 
		raylights.emitting = false
		leaves.emitting = false
		fog.visible = true
	else:
		clouds.emitting = true 

func randomWeather():
	var randomPick = randi_range(1,3)
	match randomPick:
		1:
			#print("Leaves Day")
			leaves.emitting = true
			rain.emitting = false
			raylights.emitting = true
		2:
			#print("Rainy Day")
			leaves.emitting = false
			rain.emitting = true
			raylights.emitting = false
		3,4:
			#print("Nothing Day")
			leaves.emitting = false
			rain.emitting = false
			raylights.emitting = true

func _on_inventory_gui_opened():
	get_tree().paused = true

func _on_inventory_gui_closed():
	get_tree().paused = false

