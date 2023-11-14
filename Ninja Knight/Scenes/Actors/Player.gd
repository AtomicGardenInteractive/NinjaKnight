extends CharacterBody2D
class_name Player
 
@onready
var animations = $animations
@onready
var state_machine = $state_machine

#Singleton variables that multiple states need
var prev_state: State
var has_double_jumped: = false

func _ready() -> void:
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	state_machine.init(self)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	if is_on_floor():
		has_double_jumped = false
	

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
