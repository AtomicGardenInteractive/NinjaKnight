extends State

@export_group("States")
@export
var fall_state: State
@export
var jump_state: State
@export
var move_state: State
@export
var attack_State: State
@export
var dodge_state: State
@export
var block_state: State

func enter() -> void:
	super()
	parent.velocity.x = 0

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed('move_jump') and parent.is_on_floor():
		return jump_state
	if Input.is_action_pressed("move_left") != Input.is_action_pressed("move_right"):
		return move_state
	if Input.is_action_just_pressed('attack') and parent.attack_cooldown_timer < 0:
		return attack_State
	if Input.is_action_just_pressed('move_dodge') and parent.dodge_cooldown_timer < 0:
		return dodge_state
	if Input.is_action_just_pressed('block'):
		return block_state
	if Input.is_action_just_pressed("move_drop"):
		parent.set_collision_mask(2)
	if Input.is_action_just_released("move_drop"):
		parent.set_collision_mask(1)
	
	return null
	

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state
	return null
