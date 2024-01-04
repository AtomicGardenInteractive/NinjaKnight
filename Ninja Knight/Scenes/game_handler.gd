extends Node

class_name GameHandler

signal toggle_game_paused(is_paused : bool)
signal checkpoint_activated(Checkpoint_no : int)

@export var pause_menu: Control
@export var load_menu: Control
@export var options_menu: Control

var checkpoints : Dictionary = {}
var current_checkpoint_no: int
var current_checkpoint_pos: Vector2

var game_paused: bool = false:
	get:
		return game_paused
	set(value):
		game_paused = value
		get_tree().paused = game_paused
		emit_signal("toggle_game_paused", game_paused)

func _ready():
	for child in get_children():
		if child is Checkpoint:
			checkpoints[child.name.to_lower()] = child
			child.checkpoint_activated.connect(on_checkpoint_activated)

func on_checkpoint_activated(checkpoint_no : int):
	if checkpoint_no > current_checkpoint_no:
		current_checkpoint_no = checkpoint_no
		#current_checkpoint_pos = checkpoint_pos
		print("it worked lol")

func _input(event: InputEvent):
	if(event.is_action_pressed("pause")):
		game_paused = !game_paused

func switch_menu_pause():
	pause_menu.switch_menu()

func switch_menu_load():
	load_menu.switch_menu()

func switch_menu_options():
	options_menu.switch_menu()
