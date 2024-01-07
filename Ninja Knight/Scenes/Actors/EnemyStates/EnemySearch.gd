extends EnemyState
class_name EnemySearch

@export var enemy: CharacterBody2D
@export var move_speed: float= 60.0
@export var sight_range: float= 200.0
@export var attack_range: float= 30.0

var player: CharacterBody2D

func enter():
	player = get_tree().get_first_node_in_group("Player")

func Physics_Update(_delta: float):
	var direction = (player.global_position - enemy.global_position).normalized().x
	if player.global_position.distance_to(enemy.global_position) > attack_range:
		enemy.velocity.x = direction * move_speed
	else:
		enemy.velocity.x = 0
		Transitioned.emit(self,"enemyattack")
	if player.global_position.distance_to(enemy.global_position) > sight_range:
		Transitioned.emit(self,"enemyidle")
