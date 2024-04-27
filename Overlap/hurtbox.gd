extends Area2D

const HitEffect = preload("res://Effects/Scenes/hit_effect.tscn")

@export var invincible:bool = false

@onready var timer = $Timer
@onready var collisionShape = $CollisionShape2D

signal invincibility_started
signal invincibility_ended

func start_invincibility(duration):
	self.invincible = true
	emit_signal("invincibility_started")
	timer.start(duration)

func create_hit_effect():
		var effect = HitEffect.instantiate()
		var main = get_tree().current_scene
		main.add_child(effect)
		effect.global_position = global_position

func _on_timer_timeout():
	self.invincible = false
	emit_signal("invincibility_ended")
		
func _on_invincibility_started():
	collisionShape.set_deferred('disabled', true)
	
func _on_invincibility_ended():
	collisionShape.disabled = false
