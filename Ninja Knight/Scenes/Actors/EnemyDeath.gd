extends EnemyState
class_name EnemyDeath

@export var health_pickup = preload("res://Scenes/Actors/pickup.tscn")

func enter():
	parent.is_in_pain = true
	print("just let me die")
	$"../../AnimatedSprite2D".play("Death")
	await $"../../AnimatedSprite2D".animation_finished
	parent.death()
