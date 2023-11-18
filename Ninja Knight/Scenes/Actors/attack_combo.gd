extends State

@export_group("States")
@export
var move_state: State
@export
var fall_state: State
@export
var idle_state: State

@export_group("Animation timer")
@export
var attack_time = 0.3

var attack_timer = 0.0

func enter() -> void:
	super()
	attack_timer = attack_time
	return

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	var movement = Input.get_axis('move_left', 'move_right') * move_speed
	
	if movement != 0:
		parent.animations.flip_h = movement < 0
	parent.velocity.x = movement
	parent.move_and_slide()
	
	#timers tick down with delta
	attack_timer -= delta
	
	if attack_timer <= 0:
		if !parent.is_on_floor():
			return fall_state
		if movement != 0:
			return move_state
		return idle_state
	return null


func _on_sword_hit_area_entered(area):
	pass # Replace with function body.
