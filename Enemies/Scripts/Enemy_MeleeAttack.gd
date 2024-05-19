extends EnemyState
class_name Enemy_MeleeAttack

@onready var follow : Node2D = $"../Follow"
	
func Physics(_delta : float) -> EnemyState:
	if owner.direction.length() > 5:
		return follow 
		
	return null

