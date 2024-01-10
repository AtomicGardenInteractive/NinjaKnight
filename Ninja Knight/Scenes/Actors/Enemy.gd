extends CharacterBody2D
class_name Enemy 

@export var Type : Enemy_Type
@export var enemy_health_max : int = 2
@export var enemy_damage : int = 1
@export var is_attacking_time: = 1.0
@export var fireball = preload("res://Scenes/Actors/fireball.tscn")
@export var health_pickup = preload("res://Scenes/Actors/pickup.tscn")

@export_group("SFX")
@export var Damage_FX : AudioStreamPlayer
@export var Death_FX : AudioStreamPlayer
@export var Goblin_FX : AudioStreamPlayer
@export var Jailer_FX : AudioStreamPlayer
@export var Mage_FX : AudioStreamPlayer


var player: CharacterBody2D
enum Enemy_Type {Goblin, Skeleton_Mage, Jailer}
var goblin_health : int = 2
var skeleton_health : int = 2
var jailer_health : int = 7
var enemy_health_current: int = 100
var is_attacking_timer: = 0.0
var animation_hitbox_delay_timer_goblin = -1.0
var animation_hitbox_delay_timer_skeleton_mage = -1.0
var animation_hitbox_delay_timer_Jailer = -1.0
var animation_hitbox_delay_timer_Jailer_H = -1.0
var launched_fireball = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_in_pain = false

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	match Type:
		Enemy_Type.Goblin:
			enemy_health_max = goblin_health
			$Hitbox/Goblin.disabled = false
		Enemy_Type.Skeleton_Mage:
			enemy_health_max = skeleton_health
			$Hitbox/Skeleton.disabled = false
		Enemy_Type.Jailer:
			enemy_health_max = jailer_health
			$Hitbox/Jailer.disabled = false
	enemy_health_current = enemy_health_max

func _physics_process(delta):
	move_and_slide()
	is_attacking_timer -=delta
	animation_hitbox_delay_timer_goblin -=delta
	animation_hitbox_delay_timer_skeleton_mage -=delta
	animation_hitbox_delay_timer_Jailer -=delta
	animation_hitbox_delay_timer_Jailer_H -=delta
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_attacking_timer < 0 && is_in_pain == false:
		if velocity.length() > 0:
			$AnimatedSprite2D.play("Walk")
		if velocity.length() == 0:
			$AnimatedSprite2D.play("Idle")
		if velocity.x > 0:
			$AnimatedSprite2D.flip_h = true
		elif velocity.x < 0:
			$AnimatedSprite2D.flip_h = false
	
	if is_attacking_timer > 0 :
		if animation_hitbox_delay_timer_goblin <= 0 && animation_hitbox_delay_timer_goblin >= -0.1:
			goblin_hitbox_on()
		if animation_hitbox_delay_timer_skeleton_mage <=0 && animation_hitbox_delay_timer_skeleton_mage >= -0.1:
			if launched_fireball == false:
				launched_fireball = true
				if $AnimatedSprite2D.flip_h == true:
					launch_fireball(true)
				elif $AnimatedSprite2D.flip_h == false:
					launch_fireball(false)
		if animation_hitbox_delay_timer_Jailer <= 0 && animation_hitbox_delay_timer_Jailer >= -0.1:
			Jailer_hitbox_on()
		if animation_hitbox_delay_timer_Jailer_H <= 0 && animation_hitbox_delay_timer_Jailer_H >= -0.1:
			Jailer_hitbox_on_H()


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
	Goblin_FX.play()
	animation_hitbox_delay_timer_goblin = 0.4
	await $AnimatedSprite2D.animation_finished
	$"Attack Trigger Area/GoblinRight".disabled = true
	$"Attack Trigger Area/GoblinLeft".disabled = true

func goblin_hitbox_on ():
	if $AnimatedSprite2D.flip_h == true:
		$"Attack Trigger Area/GoblinRight".disabled = false
	if $AnimatedSprite2D.flip_h == false:
		$"Attack Trigger Area/GoblinLeft".disabled = false

func skeleton_mage_attack():
	Mage_FX.play()
	is_attacking_timer = is_attacking_time
	$AnimatedSprite2D.play("Attack")
	animation_hitbox_delay_timer_skeleton_mage = 0.5
	if $AnimatedSprite2D.animation_finished:
		launched_fireball = false
	if $AnimatedSprite2D.animation_looped:
		launched_fireball = false

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
	Jailer_FX.play()
	if randi_range (0,2) > 1:
		is_attacking_timer = is_attacking_time + 0.5
		$AnimatedSprite2D.play("Attack_H")
		animation_hitbox_delay_timer_Jailer = 0.75
		await $AnimatedSprite2D.animation_finished
		print("hitbox off")
		$"Attack Trigger Area/JailerRight".disabled = true
		$"Attack Trigger Area/JailerLeft".disabled = true
	else:
		is_attacking_timer = is_attacking_time
		$AnimatedSprite2D.play("Attack")
		animation_hitbox_delay_timer_Jailer_H = 0.75
		await $AnimatedSprite2D.animation_finished
		print("hitbox off")
		$"Attack Trigger Area/JailerHRight".disabled = true
		$"Attack Trigger Area/JailerHLeft".disabled = true

func Jailer_hitbox_on ():
	if $AnimatedSprite2D.flip_h == true:
		$"Attack Trigger Area/JailerRight".disabled = false
	if $AnimatedSprite2D.flip_h == false:
		$"Attack Trigger Area/JailerLeft".disabled = false

func Jailer_hitbox_on_H ():
	if $AnimatedSprite2D.flip_h == true:
		$"Attack Trigger Area/JailerHRight".disabled = false
	if $AnimatedSprite2D.flip_h == false:
		$"Attack Trigger Area/JailerHLeft".disabled = false

func take_damage():
	Damage_FX.play()
	enemy_health_current -= 1

func death():
	Death_FX.play()
	if randi_range (0,2) > 1:
		var instance = health_pickup.instantiate()
		instance.position = global_position
		get_parent().add_child(instance)
	queue_free()

func _on_hitbox_area_entered(area):
	var detected_object = area.get_parent()
	if detected_object == player:
		take_damage()
	if detected_object == fireball:
		if detected_object.fireball.deflected == true:
			take_damage()
			detected_object.queue_free()
