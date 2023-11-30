extends CharacterBody2D

@export var enemy_health : int = 1
@export var enemy_damage : int = 1

var speed = -30
var facing_right = false
var attack_time = 0.3
var attack_timer = -0.1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$AnimatedSprite2D.play("Walk")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if !$RayCast2D.is_colliding() and is_on_floor():
		flip()
	if is_on_wall() and is_on_floor():
		flip()
	
	velocity.x = speed
	move_and_slide()
	attack_timer -= delta
	if attack_timer == 0:
		attack() 
	
func flip():
	facing_right = !facing_right
	
	scale.x = abs(scale.x) * -1
	if facing_right:
		speed = abs(speed)
	else:
		speed = abs(speed)

func _on_attack_trigger_area_area_entered(area):
		if area.get_parent() is Player:
			print("Goblin detected player")
			speed = 0
			$AnimatedSprite2D.play("Attack")
			attack_timer = attack_time
		
func attack():
	print("Goblin attacked")
	pass
