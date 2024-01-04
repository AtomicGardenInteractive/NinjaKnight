extends StaticBody2D
class_name Checkpoint

var player: Player
@export var checkpoint_no: int
var checkpoint_pos : Vector2

#signal checkpoint_activated


# Called when the node enters the scene tree for the first time.
func _ready():
	checkpoint_pos = get("position")
	print(checkpoint_pos)
	player = get_tree().get_first_node_in_group("Player")


func _on_area_2d_body_entered(body):
	if body == player:
		
		print("player entered", checkpoint_no)
