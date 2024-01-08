extends Camera2D

@export_node_path() var TargetNodepath = null
var target_node
@export var lerpspeed = 0.05
 
func _ready():
		target_node  = get_node(TargetNodepath)
		self.position = target_node.position

func _physics_process(_delta):
	self.position = lerp(self.position, (target_node.position + Vector2(0,-15)), lerpspeed)
