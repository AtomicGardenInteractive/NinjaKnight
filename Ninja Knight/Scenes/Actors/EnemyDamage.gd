extends EnemyState
class_name EnemyDamage

var damaged_timer = 0.0
var damaged_time = 0.25
var damaged_active = false

var launch_force_up: Vector2 = Vector2(0,-100)
var launch_force_sideways: Vector2 = Vector2(0,0)

func enter():
	hurties()
	parent.is_in_pain = true

func Update(_delta: float):
	damaged_timer -=_delta
	
	if damaged_active == true:
		if damaged_timer <= 0:
			damaged_active = false
			Transitioned.emit(self, "enemyidle")
	if parent.enemy_health_current <= 0:
		Transitioned.emit(self,"enemydeath")
	
func hurties():
	print(parent.name, " say's ouchies that hurt!")
	$"../../AnimatedSprite2D".play("Hit")
	print($"../../AnimatedSprite2D".animation)
	damaged_active = true
	damaged_timer = damaged_time
	if $"../../AnimatedSprite2D".flip_h == false:
		parent.velocity = (launch_force_up + launch_force_sideways)
	else:
		parent.velocity = (launch_force_up + -launch_force_sideways)
	
func exit():
	parent.is_in_pain = false
