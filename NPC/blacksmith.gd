extends StaticBody2D

var playerInArea = false
var conversationInProgress = false

func _ready():
	Dialogic.signal_event.connect(DialogicSignal)
	
func _process(_delta):
	if Input.is_action_just_pressed("talk") and playerInArea and not conversationInProgress:
		
		#TODO check time and run a different dialogue
		
		run_dialogue("Blacksmith Smithing")
	
func run_dialogue(dialogue_string):
	Dialogic.start(dialogue_string)
	conversationInProgress = true

func _on_player_detection_body_entered(body):
	if body.has_method("player"):
		playerInArea = true

func _on_player_detection_body_exited(body):
	if body.has_method("player"):
		playerInArea = false
		conversationInProgress = false
		
func DialogicSignal(arg: String):
	if arg == ("openShop"):
		print("open shop function")
		
