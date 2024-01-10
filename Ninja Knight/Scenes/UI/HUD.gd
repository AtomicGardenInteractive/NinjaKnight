extends Control

var dodge_cooldown = 4.0
var dodge_cooldown_timer = 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_healthbar(health:int):
	$"Player Bar".value = health

func _show_dash():
	pass

func _on_dash_cooldown():
	dodge_cooldown_timer = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dodge_cooldown_timer < dodge_cooldown:
		dodge_cooldown_timer +=delta
	$TextureProgressBar.value = dodge_cooldown_timer
