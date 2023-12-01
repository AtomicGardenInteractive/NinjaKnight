extends Control

@export var game_handler : GameHandler

var vis_state: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	game_handler.connect("toggle_game_paused", _on_game_handler_toggle_game_paused)
	
func _on_game_handler_toggle_game_paused(is_paused: bool):
	if(!is_paused):
		hide()
		vis_state = false

func switch_menu():
	vis_state = !vis_state
	if vis_state:
		show()
	else:
		hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
