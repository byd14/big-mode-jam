class_name FloorSprite2D extends Sprite2D

@export var offset_3d : Vector2
@export var rotation_3d : float

var copy_3d : Sprite2D

func _ready():
	if Observer.floor_is_ready:
		create_3d_copy()
	else:
		await Observer.floor_ready
		create_3d_copy()

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		if is_instance_valid(copy_3d):
			copy_3d.queue_free()

func create_3d_copy():
	copy_3d = Sprite2D.new()
	copy_3d.position = position
	copy_3d.hframes = hframes
	copy_3d.vframes = vframes
	copy_3d.frame = frame
	copy_3d.texture = texture
	copy_3d.offset -= offset + offset_3d
	copy_3d.rotation_degrees = rotation_degrees + rotation_3d
	Observer.photobooth.shadow_viewport.add_child(copy_3d)
