extends StaticBody2D

var playerInArea = false

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("talk") and playerInArea:
		Dialogic.start("Blacksmith Smithing")

func _on_player_detection_body_entered(body):
	if body.has_method("player"):
		playerInArea = true

func _on_player_detection_body_exited(body):
	if body.has_method("player"):
		playerInArea = false

func _on_dialogue_finished(dialogue_name):
	if dialogue_name == "Blacksmith Smithing":
		Dialogic.start("Evil")
