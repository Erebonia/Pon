extends Area2D

var player : Player

func can_see_player():
	return player != null

func _on_body_entered(body):
	player = body

func _on_body_exited(_body):
	player = null
