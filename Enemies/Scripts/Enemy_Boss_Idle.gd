extends Enemy_Idle

@onready var progress_bar : ProgressBar = owner.find_child("BossHealthbar")
@onready var can_attack_boss_collision : CollisionShape2D = $"../../Hurtbox/CollisionShape2D"

var player_entered_boss: bool = false:
	set(value):
		can_attack_boss_collision.set_deferred("disabled", false)
		if overhead_health_bar and progress_bar != null:
			progress_bar.set_deferred("visible",value)
			#overhead_health_bar.set_deferred("visible",value)
		
func _on_player_detection_body_entered(body):
	if body is Player:
		player_entered = true
		player_entered_boss = true
	
