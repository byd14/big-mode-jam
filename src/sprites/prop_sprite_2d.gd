class_name PropSprite2D extends Sprite2D

@export var model : PackedScene

var copy_3d : Node3D

func _ready():
	await Observer.floor_ready
	copy_3d = model.instantiate()
	copy_3d.position.x = global_position.x / 32
	copy_3d.position.z = global_position.y / 32
	Observer.photobooth.add_child(copy_3d)