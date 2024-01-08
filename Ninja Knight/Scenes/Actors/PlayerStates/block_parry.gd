extends State
@export_group("States")
@export
var idle_state: State
@export
var fall_state: State
@export
var damaged_state : State
@export
var death_grounded_state : State
@export
var death_air_state : State

@export_group("Animation Time")
@export var animation_time = 0.1

var animation_timer = 0.0

func enter() -> void:
	super()
	animation_timer = animation_time
	return

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	animation_timer -= delta
	
	if animation_timer < 0:
		return idle_state
	return null
