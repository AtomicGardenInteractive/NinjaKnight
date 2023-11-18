extends State
@export_group("States")
@export
var idle_state: State
@export
var fall_state: State
@export
var block_parry_state: State

@export_group("Parry Window")
@export var parry_time = 0.1

var parry_timer = 0.0

func enter() -> void:
	super()
	parry_timer = parry_time
	return

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_released("block"):
		if !parent.is_on_floor():
			return fall_state
		else:
			return idle_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	parry_timer -= delta
	return null


func _on_sword_hit_area_entered(area):
	if parry_timer > 0:
		return block_parry_state
	
