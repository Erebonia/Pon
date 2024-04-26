extends EnemyState
 
var can_transition: bool = false
@export var DASH_SPEED = 0.4
 
func enter():
	super.enter()
	animation_player.play("glowing")
	await dash()
	can_transition = true
 
func dash():
	var tween = create_tween()
	if player != null:
		tween.tween_property(owner, "position", player.position, DASH_SPEED)
		await tween.finished
 
func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("MeleeAttack")
