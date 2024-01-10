extends State

@export_group("States")
@export
var idle_state: State
@export
var move_state: State
@export
var jump_state: State
@export
var attack_state: State
@export
var double_jump_state : State
@export
var dodge_state: State
@export
var damaged_state : State
@export
var death_grounded_state : State
@export
var death_air_state : State

@export_group("Player safeguards Properties")
@export var jump_buffer_time = 0.3
@export var attack_buffer_time = 0.1
@export var coyote_time = 0.2

#timers
var jump_buffer_timer : float = 0.0
var attack_buffer_timer : float = 0.0
var coyote_timer: float = 0.0

#sets/resets timers on state change
func enter() -> void:
	super()
	jump_buffer_timer = 0.0
	attack_buffer_timer = 0.0
	coyote_timer = coyote_time
	return


func process_input(_event: InputEvent) -> State:
	
	if Input.is_action_just_pressed('move_dodge') and parent.dodge_cooldown_timer < 0:
		return dodge_state
	
	if coyote_timer > 0 and parent.prev_state != jump_state and parent.prev_state != double_jump_state:
		if Input.is_action_just_pressed('move_jump') and parent.prev_state != jump_state:
			return jump_state
	elif Input.is_action_just_pressed('move_jump') and !parent.has_double_jumped and parent.double_jump_item == true:
		parent.has_double_jumped = true
		return double_jump_state
	elif Input.is_action_just_pressed('move_jump'):
		print("buffer time") 
		jump_buffer_timer = jump_buffer_time

	if Input.is_action_just_pressed('attack'):
		attack_buffer_timer = attack_buffer_time
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	#timers tick down with delta
	coyote_timer -= delta
	jump_buffer_timer -= delta
	
	var movement = 0
	if Input.is_action_pressed("move_left"):
		movement -= 1
	if Input.is_action_pressed("move_right"):
		movement += 1
	movement *= move_speed
	
	if movement != 0:
		parent.animations.flip_h = movement < 0
	parent.velocity.x = movement
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if jump_buffer_timer > 0:
			return jump_state
		if attack_buffer_timer > 0:
			return attack_state
		if movement != 0:
			return move_state
		return idle_state
	
	if parent.player_health_current <= 0:
		if parent.is_on_floor():
			return death_grounded_state
		else:
			return death_air_state
	
	if parent.player_health_current < player_health:
		return damaged_state
	return null
