extends ProgressBar

class_name healthbar_overhead

@onready var timer = $Timer
@onready var damage_bar = $DamageBar

var health = 0 : set = _set_health

func _set_health(new_health):
	var prev_health = health
	health = min(max_value, new_health)
	value = health

	var halfHP = max_value / 2
	var lowHP = max_value / 3
	
	# Check if health is less than or equal to one-third
	if health <= lowHP:
		var theme_stylebox = get_theme_stylebox("fill").duplicate()
		theme_stylebox.bg_color = Color("#FF0000")  # Red color
		add_theme_stylebox_override("fill", theme_stylebox)
	# Check if health is less than or equal to half
	elif health <= halfHP:
		var theme_stylebox = get_theme_stylebox("fill").duplicate()
		theme_stylebox.bg_color = Color("#FFFF00")  # Yellow color
		add_theme_stylebox_override("fill", theme_stylebox)
	# Default color for health above half
	elif health > halfHP:
		var theme_stylebox = get_theme_stylebox("fill").duplicate()
		theme_stylebox.bg_color = Color("#00FF00")  # Green color
		add_theme_stylebox_override("fill", theme_stylebox)
		
	if health <= 0:
		queue_free()
		
	if health < prev_health:
		timer.start()
	else:
		damage_bar.value = health


func init_health(_health):
	health = _health
	max_value = health
	value = health
	damage_bar.max_value = health
	damage_bar.value = health

func _on_timer_timeout():
	damage_bar.value = health

