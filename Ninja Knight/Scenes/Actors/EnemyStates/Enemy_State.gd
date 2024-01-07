extends Node
class_name EnemyState

signal Transitioned

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var parent: Enemy

func enter():
	pass

func exit():
	pass

func Update(_delta: float):
	pass

func Physics_Update(_delta: float):
	pass
