extends Control

@export var game_handler : GameHandler
@export var options_menu : CanvasLayer
@export var load_menu : CanvasLayer

var vis_state: bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	game_handler.connect("toggle_game_paused", _on_game_handler_toggle_game_paused)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_game_handler_toggle_game_paused(is_paused: bool):
	if(is_paused):
		show()
		vis_state = true
	else:
		hide()
		vis_state = false

func switch_menu():
	vis_state = !vis_state
	if vis_state:
		show()
	else:
		hide()

func _on_resume_pressed():
	game_handler.game_paused = false


func _on_quit_pressed():
	get_tree().quit()


func _on_load_pressed():
	switch_menu()
	game_handler.switch_menu_load()


func _on_options_pressed():
	switch_menu()
	game_handler.switch_menu_options()
