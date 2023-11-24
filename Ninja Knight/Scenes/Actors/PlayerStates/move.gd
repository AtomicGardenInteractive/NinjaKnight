extends State

@export_group("States")
@export
var fall_state: State
@export
var idle_state: State
@export
var jump_state: State
@export
var attack_state: State
@export
var dodge_state: State
@export
var block_state: State


func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed('move_jump') and parent.is_on_floor():
		return jump_state
	if Input.is_action_just_pressed("attack") and parent.attack_cooldown_timer < 0:
		return attack_state
	if Input.is_action_just_pressed('move_dodge') and parent.dodge_cooldown_timer < 0:
		return dodge_state
	if Input.is_action_just_pressed('block'):
		return block_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	var movement = Input.get_axis('move_left','move_right') * move_speed
	
	if movement == 0:
		return idle_state
	
	parent.animations.flip_h = movement < 0
	parent.velocity.x = movement
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state
	return null
