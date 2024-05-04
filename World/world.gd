extends BaseScene

var checkTime = DayAndNight.get_child(1)
@onready var camera = $World_Camera

func _ready():
	super()
	#camera.follow_node = player
	checkTime.connect("time_tick", Callable(self, "_on_check_time"))

func _on_check_time(_day, hour, _minute):
	#24 hour Clock
	if (hour >= 19 and hour <= 23) or (hour >= 0 and hour < 5):
		$"Environment/Day Godrays".visible = false
		$"Environment/Night Godrays".visible = true
		$Environment/FogShader.visible = true
	else:
		$"Environment/Day Godrays".visible = true
		$"Environment/Night Godrays".visible = false
		$Environment/FogShader.visible = false

func _on_inventory_gui_opened():
	get_tree().paused = true

func _on_inventory_gui_closed():
	get_tree().paused = false
