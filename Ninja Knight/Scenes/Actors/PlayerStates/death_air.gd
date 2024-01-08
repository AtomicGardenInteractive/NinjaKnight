extends State

@export_group("States")
@export
var idle_state: State

@export_group("SFX")
@export var Death_FX : AudioStreamPlayer

var anim_finished = false

func enter() -> void:
	super()
	leaver()

func leaver():
	await $"../../animations".animation_finished
	anim_finished = true

func process_frame(_delta: float) -> State:
	if anim_finished == true:
		anim_finished = false
		return idle_state
	return
