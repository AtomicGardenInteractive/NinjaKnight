extends CharacterBody2D
class_name Player
 
@onready
var animations = $animations
@onready
var state_machine = $state_machine

#Singleton variables that multiple states need
var prev_state: State
var has_double_jumped: = false

@export var dodge_cooldown: float = 3.0
@export var attack_cooldown: float = 0.25

var dodge_cooldown_timer: float = 0.0
var attack_cooldown_timer: float = 0.0

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
	dodge_cooldown_timer -= delta
	attack_cooldown_timer -= delta
