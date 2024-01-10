extends State

@export_group("States")
@export
var move_state: State
@export
var fall_state: State
@export
var idle_state: State
@export
var attack_combo_state: State
@export
var damaged_state : State
@export
var death_grounded_state : State
@export
var death_air_state : State

@export_group("Animation timer")
@export
var attack_time = 0.35
var damage = 1

@export_group("SFX")
@export var Attack_FX : AudioStreamPlayer

#combo trigger
var combo_ready = false
#timers
var attack_timer = 0.0

#sets/resets timers on state change
func enter() -> void:
	super()
	Attack_FX.play()
	attack_timer = attack_time
	if $"../../animations".flip_h == false:
		$"../../SwordHit/Attack Area Right".disabled = false
	else:
		$"../../SwordHit/Attack Area Left".disabled = false
	return

func exit() -> void:
	super()
	parent.attack_cooldown_timer = parent.attack_cooldown
	$"../../SwordHit/Attack Area Right".disabled = true
	$"../../SwordHit/Attack Area Left".disabled = true

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed("attack"):
		combo_ready = true
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	var movement = Input.get_axis('move_left', 'move_right') * move_speed
	
	if movement != 0:
		parent.animations.flip_h = movement < 0
	parent.velocity.x = movement
	parent.move_and_slide()
	
	#timers tick down with delta
	attack_timer -= delta
	
	if attack_timer < 0:
		if combo_ready:
			combo_ready = false
			return attack_combo_state
		if !parent.is_on_floor():
			return fall_state
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

