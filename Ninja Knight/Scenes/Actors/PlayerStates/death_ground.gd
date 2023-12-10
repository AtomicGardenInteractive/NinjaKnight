extends State

@export_group("States")
@export
var idle_state: State

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed("Debug_Death"):
		return idle_state
	return
