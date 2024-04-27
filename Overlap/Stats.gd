extends Node

class_name Stats

@export var max_health = 100
@export var DEF = 0
@export var KNOCKOUT_SPEED = 0
@onready var health = max_health:
	get: 
		return health
	set(value): 
		health = value
		emit_signal("health_changed", health)
		if health <= 0:
			emit_signal("no_health")
		
signal no_health
signal health_changed(value)
signal max_health_changed(value)

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed")
