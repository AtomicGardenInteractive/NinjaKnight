extends State

@export_group("States")
@export
var idle_state: State

@export_group("SFX")
@export var Death_FX : AudioStreamPlayer

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed("Debug_Death"):
		return idle_state
	return
