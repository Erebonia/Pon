extends StaticBody2D

var player_in_area = false
var conversation_in_progress = false

func _ready():
	pass
	
func _process(_delta):
	if Input.is_action_just_pressed("talk") and player_in_area and not conversation_in_progress:
		
		#TODO check time and run a different dialogue
		run_dialogue("roy_talk_1")
	
func run_dialogue(dialogue_string):
	Dialogic.start(dialogue_string)
	conversation_in_progress = true

func _on_player_detection_body_entered(body):
	if body is Player:
		player_in_area = true

func _on_player_detection_body_exited(body):
	if body is Player:
		player_in_area = false
		conversation_in_progress = false
		
