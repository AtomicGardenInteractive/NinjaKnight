extends CharacterBody2D
class_name Enemy 

@export var enemy_health_max : int = 2
@export var enemy_damage : int = 1
@export var is_attacking_time: = 1.0

var player: CharacterBody2D
var enemy_health_current: int = 100
var is_attacking_timer: = 0.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func enter():
	player = get_tree().get_first_node_in_group("Player")
	enemy_health_current = enemy_health_max
#var speed = -30
#var facing_right = false
#var attack_time = 0.3
#var attack_timer = -0.1
#
# Get the gravity from the project settings to be synced with RigidBody nodes.

#
#func _ready():
#	$AnimatedSprite2D.play("Walk")
#
#
func _physics_process(delta):
	move_and_slide()
	is_attacking_timer -=delta
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_attacking_timer < 0:
		if velocity.length() > 0:
			$AnimatedSprite2D.play("Walk")
		if velocity.length() == 0:
			$AnimatedSprite2D.play("Idle")
		if velocity.x > 0:
			$AnimatedSprite2D.flip_h = true
		elif velocity.x < 0:
			$AnimatedSprite2D.flip_h = false


#	if !$RayCast2D.is_colliding() and is_on_floor():
#		flip()
#	if is_on_wall() and is_on_floor():
#		flip()
#
#	velocity.x = speed
#	move_and_slide()
#	attack_timer -= delta
#	if attack_timer == 0:
#		attack() 
#
#func flip():
#	facing_right = !facing_right
#
#	scale.x = abs(scale.x) * -1
#	if facing_right:
#		speed = abs(speed)
#	else:
#		speed = abs(speed)
#
#func _on_attack_trigger_area_area_entered(area):
#	print("spotted" + area.overlap)
#
#	if area.get_parent() is Player:
#		print("Goblin detected player")
#		speed = 0
#		$AnimatedSprite2D.play("Attack")
#		attack_timer = attack_time
#
#func attack():
#	print("Goblin attacked")
#	pass


func _on_attack_trigger_area_body_entered(body):
	for child in body.get_children():
		if child is Damageable:
			child.hit(enemy_damage)
			is_attacking_timer = is_attacking_time
			$AnimatedSprite2D.play("Attack")
