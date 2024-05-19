extends Base_Scene
class_name World

@onready var camera : Camera2D = $World_Camera
@onready var clouds : GPUParticles2D = $World_Camera/Cloud
@onready var raylights : GPUParticles2D = $World_Camera/Raylight
@onready var leaves : GPUParticles2D = $World_Camera/Leaf
@onready var rain : GPUParticles2D = $World_Camera/Rain
@onready var fog : ParallaxBackground = $Environment/FogShader

var check_time : Node2D = DayAndNight.get_child(1)
var saved_day: int
var saved_hour: int

func _ready():
	super()
	check_time.connect("time_tick", Callable(self, "_on_check_time"))

func _on_check_time(day, hour, _minute):
	# Randomize Weather every 12 hours
	if saved_hour == -1 or hour == (saved_hour + 12) % 24:
		#print("Hour: " + str(hour))
		randomWeather()
		saved_hour = hour
	
	# Update saved_day at midnight
	if saved_day != day:
		saved_day = day
		
	#Night Time
	if (hour >= 19 and hour <= 23) or (hour >= 0 and hour < 6):
		clouds.emitting = false 
		raylights.emitting = false
		leaves.emitting = false
		fog.visible = true
	else:
		clouds.emitting = true 

func randomWeather():
	var pick_random_weather = randi_range(1,3)
	match pick_random_weather:
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


