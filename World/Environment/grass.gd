extends Node2D

#Preload it 
const GrassEffect = preload("res://Effects/Scenes/grass_effect.tscn")

func create_grass_effect():
	#Instance the Scene
	var grassEffect = GrassEffect.instantiate()

	#Adds the effect
	get_parent().add_child(grassEffect)

	#Puts the effect in the same position as the instance we made.
	grassEffect.global_position = global_position
	
	AudioManager.get_node("Grass_SFX").play()
	queue_free()

func _on_hurtbox_area_entered(_area):
	create_grass_effect()
	queue_free()
