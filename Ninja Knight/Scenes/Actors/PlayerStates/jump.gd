extends State

@export_group("States")
@export
var fall_state: State
@export
var idle_state: State
@export
var move_state: State
@export
var double_jump_state: State
@export
var dodge_state: State

@export_group ("Other")
@export
var jump_force: float = 400.0

func enter() -> void:
	super()
	parent.set_collision_mask(2)
	parent.velocity.y = -jump_force
	return
func exit() -> void:
	super()
	parent.set_collision_mask(1)
	return

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed('move_jump') and parent.prev_state != double_jump_state:
		parent.has_double_jumped = true
		return double_jump_state
	if Input.is_action_just_pressed('move_dodge') and parent.dodge_cooldown_timer < 0:
		return dodge_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	if parent.velocity.y > 0:
		return fall_state
	
	var movement = Input.get_axis('move_left', 'move_right') * move_speed
	
	if movement != 0:
		parent.animations.flip_h = movement < 0
	parent.velocity.x = movement
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if movement != 0:
			return move_state
		return idle_state
	
	return null

