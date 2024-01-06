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
@export var player_health_max: int = 7

var player_health_current: int = player_health_max
var dodge_cooldown_timer: float = 0.0
var attack_cooldown_timer: float = 0.0

@export var start_checkpoint: Checkpoint
var checkpoint_current: Checkpoint

func _ready() -> void:
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	state_machine.init(self)
	checkpoint_current = start_checkpoint
	self.position = checkpoint_current.global_position

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

func take_damage():
	player_health_current -= 1
	print("hurt", player_health_current)
	if player_health_current <= 0:
		die()

func die():
	if checkpoint_current != null:
		self.position = checkpoint_current.global_position
		player_health_current = player_health_max

func _on_detector_area_entered(area):
	if area.get_parent() is Checkpoint:
		if area.get_parent().checkpoint_no > checkpoint_current.checkpoint_no:
			checkpoint_current = area.get_parent()
			print(checkpoint_current.checkpoint_no)
	elif area.get_parent() is Spikes or Enemy:
		take_damage()
