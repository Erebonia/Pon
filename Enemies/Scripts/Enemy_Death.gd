extends EnemyState
class_name Enemy_Death

func Enter():
	#Handled death in main class due to it bugging out here.
	Status.current_xp += 240
