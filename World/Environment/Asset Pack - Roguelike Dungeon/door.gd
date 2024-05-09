extends StaticBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func open() -> void:
	animation_player.play("open")
	AudioManager.get_node("Door_Open").play()
