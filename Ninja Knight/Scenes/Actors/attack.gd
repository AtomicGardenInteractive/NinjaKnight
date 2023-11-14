extends State

@export_group("States")
@export
var move_state: State
@export
var fall_state: State
@export
var idle_state: State
@export
var attack_combo_state: State

@export_group("Animation timer")
@export
var attack_time = 0.3

#combo trigger
var combo_ready = false
#timers
var attack_timer = 0.0

#sets/resets timers on state change
func enter() -> void:
	parent.animations.play(animation_name)
	attack_timer = attack_time
	return

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed("attack"):
		combo_ready = true
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	var movement = Input.get_axis('move_left', 'move_right') * move_speed
	
	if movement != 0:
		parent.animations.flip_h = movement < 0
	parent.velocity.x = movement
	parent.move_and_slide()
	
	#timers tick down with delta
	attack_timer -= delta
	
	if attack_timer < 0:
		if combo_ready:
			combo_ready = false
			return attack_combo_state
		if !parent.is_on_floor():
			return fall_state
		if movement != 0:
			return move_state
		return idle_state
	return null
