extends Node

class_name Damageable

@export var health : int = 10
@export var parent : CharacterBody2D

func hit(damage : int):
	print("ouchies")
	health -= damage
	if (health <= 0):
		print("dead")
		#get_parent().queue_free()
