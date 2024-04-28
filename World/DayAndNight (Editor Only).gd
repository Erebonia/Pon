extends CanvasModulate

func _ready():
	print("This is for the editor only. Destroyed.")
	queue_free()
