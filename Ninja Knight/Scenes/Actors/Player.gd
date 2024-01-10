extends CharacterBody2D
class_name Player

signal HP_update
signal Dash_cooldown

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

var parry_item: bool = false
var double_jump_item: bool = false


@export var start_checkpoint: Checkpoint
var checkpoint_current: Checkpoint

@export_group("SFX")
@export var Pickup_FX : AudioStreamPlayer

func _ready() -> void:
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	state_machine.init(self)
	checkpoint_current = start_checkpoint
	self.position = checkpoint_current.global_position

func dodge_used():
	Dash_cooldown.emit()

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
	if player_health_current > player_health_max:
		player_health_current = player_health_max

func take_damage():
	player_health_current -= 1
	HP_update.emit(player_health_current)
	if player_health_current <= 0:
		die()

func die():
	await $animations.animation_finished
	if checkpoint_current != null:
		self.position = checkpoint_current.global_position
		player_health_current = player_health_max
		HP_update.emit(player_health_current)

func _on_detector_area_entered(area):
	var detected_object: Node2D = area.get_parent()
	if detected_object is Checkpoint:
		if detected_object.checkpoint_no > checkpoint_current.checkpoint_no:
			checkpoint_current = detected_object
			print(checkpoint_current.checkpoint_no)
	
	if detected_object is Pickup:
		var picked_up_item: Pickup = detected_object
		Pickup_FX.play()
		match picked_up_item.type:
			picked_up_item.Pickup_type.Health:
				player_health_current += 2
				HP_update.emit(player_health_current)
				picked_up_item.queue_free()
				
			picked_up_item.Pickup_type.Double_item:
				double_jump_item = true
				picked_up_item.queue_free()
				
			picked_up_item.Pickup_type.Parry_item:
				parry_item = true
				picked_up_item.queue_free()
	
	if detected_object is Spikes :
		print(detected_object.name)
		take_damage()
	
	if detected_object is Fireball :
		if $state_machine.current_state == $state_machine/block:
			detected_object._been_deflected
		else:
			take_damage()
			detected_object.queue_free()
	
	if detected_object is Enemy :
		print(detected_object.name)
		take_damage()
