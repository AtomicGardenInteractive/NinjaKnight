extends RigidBody2D
class_name Fireball


var fb_velocity = Vector2(-1,0)
var speed = 300
var flipsprite = false
var deflected = false
# Called when the node enters the scene tree for the first time.
func _ready():
	if flipsprite == true:
		$AnimatedSprite2D.flip_h = true
	$AnimatedSprite2D.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_collide(fb_velocity.normalized() * delta * speed)
