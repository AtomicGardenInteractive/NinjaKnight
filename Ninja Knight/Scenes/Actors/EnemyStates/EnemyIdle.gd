extends EnemyState
class_name EnemyIdle

@export var enemy: CharacterBody2D
@export var move_speed: float= 50.0
@export var sight_range: float= 200.0

var player: CharacterBody2D

var move_direction : float
var wander_time: float

func randomise_wander():
	move_direction = randi_range(-1, 1)
	wander_time = randf_range (1, 3)
	
func enter():
	super()
	player = get_tree().get_first_node_in_group("Player")
	randomise_wander()

func Update(delta: float):
	if wander_time > 0:
		wander_time -= delta
	else:
		randomise_wander()

func Physics_Update(_delta: float):
	if enemy:
		enemy.velocity.x = move_direction * move_speed
		
	if player.global_position.distance_to(enemy.global_position) < sight_range:
		Transitioned.emit(self,"enemysearch")
