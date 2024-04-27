extends Resource

@export var health: int
@export var savedPosition: Vector2

func loadSavedPosition(value: Vector2):
	value = savedPosition
