extends Resource
class_name PlayerData

@export var health: int
@export var savedPosition: Vector2

func loadSavedPosition(value: Vector2):
	savedPosition = value
