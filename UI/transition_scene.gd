extends CanvasLayer

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer

func _ready():
	color_rect.visible = false
	
func transition():
	color_rect.visible = true
	animation_player.play("fade out")
