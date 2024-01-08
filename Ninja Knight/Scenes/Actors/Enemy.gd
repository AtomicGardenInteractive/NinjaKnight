extends CharacterBody2D
class_name Enemy 

@export var Type : Enemy_Type
@export var enemy_health_max : int = 2
@export var enemy_damage : int = 1
@export var is_attacking_time: = 1.0
@export var fireball = preload("res://Scenes/Actors/fireball.tscn")


var player: CharacterBody2D
enum Enemy_Type {Goblin, Skeleton_Mage, Jailer}
var enemy_health_current: int = 100
var is_attacking_timer: = 0.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func enter():
	player = get_tree().get_first_node_in_group("Player")
	enemy_health_current = enemy_health_max

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

func goblin_attack():
	is_attacking_timer = is_attacking_time
	$AnimatedSprite2D.play("Attack")
	if $AnimatedSprite2D.flip_h == true:
		$"Attack Trigger Area/GoblinRight".disabled = false
	if $AnimatedSprite2D.flip_h == false:
		$"Attack Trigger Area/GoblinLeft".disabled = false
	await $AnimatedSprite2D.animation_finished
	$"Attack Trigger Area/GoblinRight".disabled = true
	$"Attack Trigger Area/GoblinLeft".disabled = true

func skeleton_mage_attack():
	is_attacking_timer = is_attacking_time
	$AnimatedSprite2D.play("Attack")
	if $AnimatedSprite2D.flip_h == true:
		launch_fireball(true)
	elif $AnimatedSprite2D.flip_h == false:
		launch_fireball(false)
	await $AnimatedSprite2D.animation_finished

func launch_fireball(leftright:bool):
	if leftright == false:
		var instance = fireball.instantiate()
		instance.position = $Marker2DLeft.global_position
		get_parent().add_child(instance)
	elif leftright == true:
		var instance = fireball.instantiate()
		instance.fb_velocity = Vector2(1,0)
		instance.flipsprite = true
		instance.position = $Marker2DRight.global_position
		get_parent().add_child(instance)

func jailer_attack():
	if randi_range (0,2) > 1:
		is_attacking_timer = is_attacking_time + 0.5
		$AnimatedSprite2D.play("Attack_H")
		if $AnimatedSprite2D.flip_h == true:
			$"Attack Trigger Area/JailerRight".disabled = false
		if $AnimatedSprite2D.flip_h == false:
			$"Attack Trigger Area/JailerLeft".disabled = false
		await $AnimatedSprite2D.animation_finished
		$"Attack Trigger Area/JailerRight".disabled = true
		$"Attack Trigger Area/JailerLeft".disabled = true
	else:
		is_attacking_timer = is_attacking_time
		$AnimatedSprite2D.play("Attack")
		if $AnimatedSprite2D.flip_h == true:
			$"Attack Trigger Area/JailerHRight".disabled = false
		if $AnimatedSprite2D.flip_h == false:
			$"Attack Trigger Area/JailerHLeft".disabled = false
		await $AnimatedSprite2D.animation_finished
		$"Attack Trigger Area/JailerHRight".disabled = true
		$"Attack Trigger Area/JailerHLeft".disabled = true
