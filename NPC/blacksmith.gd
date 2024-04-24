extends StaticBody2D

func _ready():
	pass
	
func _process(delta):
	if Input.is_key_pressed(KEY_Y):
		run_dialogue("Blacksmith Smithing")

func run_dialogue(dialogue_string):
	Dialogic.start(dialogue_string)
