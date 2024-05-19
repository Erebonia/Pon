extends Camera2D

@onready var topLeft : Node2D = $Limits/TopLeft
@onready var bottomRight : Node2D = $Limits/BottomRight

func _ready():
	limit_top = topLeft.position.y
	limit_left = topLeft.position.x
	limit_bottom = bottomRight.position.y
	limit_right = bottomRight.position.x
