extends State

## Collsion on head object refrences
@onready var rc_left = $"../../animations/Head Colision Detection/RC Left"
@onready var rc_mid = $"../../animations/Head Colision Detection/RC Mid"
@onready var rc_right = $"../../animations/Head Colision Detection/RC Right"


@export_group("States")
@export
var self_state: State
@export
var fall_state: State
@export
var idle_state: State
@export
var move_state: State

## Public Vars
@export
var jump_force: float = 400.0

func enter() -> void:
	super()
	parent.velocity.y = -jump_force
	

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	if parent.velocity.y > 0:
		return fall_state
	
	if rc_right.is_colliding() and !rc_mid.is_colliding() \
		and !rc_left.is_colliding():
			parent.global_position.x -= 5
			print("Moved +5")
	elif rc_left.is_colliding() and !rc_mid.is_colliding() \
		and !rc_right.is_colliding():
			parent.global_position.x = 5
			print("Moved -5")
	
	var movement = Input.get_axis('move_left', 'move_right') * move_speed
	
	if movement != 0:
		parent.animations.flip_h = movement < 0
	parent.velocity.x = movement
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if movement != 0:
			return move_state
		return idle_state
	
	return null
	
func exit() ->void:
	parent.coyotetime_enabled = false
	"prev_state = self_state
	print(prev_state)"
