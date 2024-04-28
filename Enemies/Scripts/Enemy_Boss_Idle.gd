extends Enemy_Idle

@onready var progress_bar = owner.find_child("BossHealthbar")
@onready var canAttackBossCollision = $"../../Hurtbox/CollisionShape2D"

var player_entered_boss: bool = false:
	set(value):
		canAttackBossCollision.set_deferred("disabled", false)
		#progress_bar.set_deferred("visible",value)
		overhead_health_bar.set_deferred("visible",value)
		
func _on_player_detection_body_entered(body):
	if body.has_method("player"):
		player_entered = true
		player_entered_boss = true
	
