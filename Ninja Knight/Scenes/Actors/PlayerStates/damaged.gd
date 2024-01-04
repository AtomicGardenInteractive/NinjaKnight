extends State

@export_group("States")
@export
var idle_state: State

@export_group ("Other")
@export
var launch_force_up: Vector2 = Vector2(0,-200)
@export
var launch_force_sideways: Vector2 = Vector2(200,0)

@export_group("SFX")
@export var Damage_FX : AudioStreamPlayer

func enter() -> void:
	super()
	if parent.animations.flip_h == true:
		parent.velocity = (launch_force_up + launch_force_sideways)
	else:
		parent.velocity = (launch_force_up + -launch_force_sideways)
	return

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	
	if parent.is_on_floor():
		return idle_state
	return
