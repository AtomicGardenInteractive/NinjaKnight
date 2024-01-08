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
@export
var damaged_state : State
@export
var death_grounded_state : State
@export
var death_air_state : State

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed('move_jump') and parent.is_on_floor():
		return jump_state
	if Input.is_action_just_pressed("attack") and parent.attack_cooldown_timer < 0:
		return attack_state
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
	
	var movement = 0
	if Input.is_action_pressed("move_left"):
		movement -= 1
	if Input.is_action_pressed("move_right"):
		movement += 1
	movement *= move_speed
	#Broken
	#var movement = Input.get_axis('move_left','move_right') * move_speed
	
	if movement == 0:
		return idle_state
	
	parent.animations.flip_h = movement < 0
	parent.velocity.x = movement
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state
		
	if parent.player_health_current <= 0:
		if parent.is_on_floor():
			return death_grounded_state
		else:
			return death_air_state
	
	if parent.player_health_current < player_health:
		return damaged_state
	
	return null
