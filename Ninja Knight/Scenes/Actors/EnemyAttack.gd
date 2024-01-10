extends EnemyState
class_name EnemyAttack

var player: CharacterBody2D

var animation_timer : float
var attacking = false
var current_health : int

func enter():
	current_health = parent.enemy_health_current
	player = get_tree().get_first_node_in_group("Player")
	attack()

func exit():
	pass

func Update(_delta: float):
	animation_timer -=_delta
	
	if animation_timer <= 0 && attacking == true:
		attacking = false
		leave()
	
	if parent.enemy_health_current <= 0:
		Transitioned.emit(self,"enemydeath")
	elif parent.enemy_health_current != current_health:
		Transitioned.emit(self,"enemydamage")

func Physics_Update(_delta: float):
	pass

func attack():
	match parent.Type:
		parent.Enemy_Type.Goblin:
			parent.goblin_attack()
			animation_timer = 1
			attacking = true

		parent.Enemy_Type.Skeleton_Mage:
			parent.skeleton_mage_attack()
			animation_timer = 1
			attacking = true

		parent.Enemy_Type.Jailer:
			parent.jailer_attack()
			animation_timer = 2
			attacking = true


func leave():
	Transitioned.emit(self,"enemysearch")
