class_name PropSprite2D extends Sprite2D

@export var model : PackedScene

func _ready():
	await Observer.floor_ready
	var i : Node3D = model.instantiate()
	i.position.x = global_position.x / 32
	i.position.z = global_position.y / 32
	Observer.photobooth.add_child(i)
