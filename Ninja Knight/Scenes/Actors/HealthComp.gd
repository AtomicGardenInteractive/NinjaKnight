extends Node2D
class_name HealthComp

@export var Max_Health := 10.0
var current_health : float

func _ready():
	current_health = Max_Health

	"if current_health <= 0:
		get_parent().queue_free()"

