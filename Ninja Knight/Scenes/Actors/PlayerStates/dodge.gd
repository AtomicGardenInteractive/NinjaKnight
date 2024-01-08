extends State

@export_group("States")
@export
var fall_state: State
@export
var idle_state: State
@export
var move_state: State
@export
var jump_state: State
@export
var attack_state: State

@export_group("SFX")
@export var Dodge_FX : AudioStreamPlayer

@export_group ("Other")
@export var dodge_force: float = 500.0
@export var jump_buffer_time = 0.3
@export var attack_buffer_time = 0.1
@export var dodge_time: float = 0.25

var jump_buffer_timer : float = 0.0
var attack_buffer_timer : float = 0.0
var dodge_timer : float = 0.0

func enter() -> void:
	super()
	parent.set_collision_layer(2)
	parent.set_collision_mask(2)

	parent.velocity = Vector2(0,0)
	if parent.animations.flip_h:
		parent.velocity.x = -dodge_force
	else:
		parent.velocity.x = dodge_force
	jump_buffer_timer = 0.0
	attack_buffer_timer = 0.0
	dodge_timer = dodge_time
	return

func process_input(_event: InputEvent) -> State:
	
	if Input.is_action_just_pressed('move_jump'):
		jump_buffer_timer = jump_buffer_time
	
	if Input.is_action_just_pressed('attack'):
		attack_buffer_timer = attack_buffer_time
	return null

func process_physics(delta: float) -> State:
	dodge_timer -= delta
	
	parent.move_and_slide()
	
	if parent.is_on_floor() and dodge_timer < 0:
		if jump_buffer_timer > 0:
			return jump_state
		if attack_buffer_timer > 0:
			return attack_state
		return idle_state
	elif dodge_timer < 0:
		return fall_state
	return null

func exit() -> void:
	super()
	parent.set_collision_layer(1)
	parent.set_collision_mask(1)
	parent.dodge_cooldown_timer = parent.dodge_cooldown
	return

func player_hit():
	return null
