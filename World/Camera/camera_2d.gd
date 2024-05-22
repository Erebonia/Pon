extends Camera2D

@onready var topLeft : Node2D = $Limits/TopLeft
@onready var bottomRight : Node2D = $Limits/BottomRight

func _ready():
	limit_top = int(topLeft.position.y)
	limit_left = int(topLeft.position.x)
	limit_bottom = int(bottomRight.position.y)
	limit_right = int(bottomRight.position.x)

