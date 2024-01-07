extends EnemyState
class_name EnemyAttack

var player: CharacterBody2D


func enter():
	super()
	player = get_tree().get_first_node_in_group("Player")
	print("attack entered")
	match parent.Type:
		parent.Enemy_Type.Goblin:
			parent.goblin_attack()
			Transitioned.emit(self,"enemysearch")
		parent.Enemy_Type.Skeleton_Mage:
			parent.skeleton_mage_attack()
			Transitioned.emit(self,"enemysearch")
		parent.Enemy_Type.Jailer:
			parent.jailer_attack()
			Transitioned.emit(self,"enemysearch")
			print("I should have left the attack state")
		_:
			print("I'm an attacking ","Error")
			Transitioned.emit(self,"enemyidle")
			
func exit():
	pass

func Update(_delta: float):
	pass

func Physics_Update(_delta: float):
	pass
