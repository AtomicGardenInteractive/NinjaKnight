extends Node2D
class_name Pickup


@export var type : Pickup_type
enum Pickup_type {Health, Double_item, Parry_item}

@export_group("Textures")
@export var health_texture: Texture2D
@export var Double_item_texture: Texture2D
@export var Parry_item_texture: Texture2D

# Called when the node enters the scene tree for the first time.
func _ready():
	match type:
		Pickup_type.Health:
			$Sprite2D.set_texture(health_texture)
		Pickup_type.Double_item:
			$Sprite2D.set_texture(Double_item_texture)
		Pickup_type.Parry_item:
			$Sprite2D.set_texture(Parry_item_texture)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimationPlayer.play("Drift")


func _on_area_2d_area_entered(area):
	if area.get_parent() is Player:
		print("pick up dectects player")
		self.queue_free()
