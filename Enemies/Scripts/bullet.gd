extends Area2D

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var player : Player = get_parent().find_child("Player")
@onready var player_last_location : Vector2
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var animationPlayer : AnimationPlayer = $AnimationPlayer
@onready var hurtbox : Area2D = $Hurtbox

@export var damage = 1
 
var acceleration: Vector2 = Vector2.ZERO 
var velocity: Vector2 = Vector2.ZERO
var direction : Vector2

func _physics_process(delta):
	if player != null:
		player_last_location = player.position
		acceleration = (player_last_location - position).normalized() * 700
		velocity += acceleration * delta
		rotation = velocity.angle()
		velocity = velocity.limit_length(150)
		position += velocity * delta
		
		if direction.x < 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
	 
func projectile():
	pass

func _on_hurtbox_area_entered(area):
	if area.has_method("playerWeapon"):
		print("Projectile has been slashed by the player.")
		queue_free()
		hurtbox.create_hit_effect(area.global_position)

func _on_timer_timeout():
	queue_free()
