class_name PlaneSprite2D extends Sprite2D

@export var offset_3d : Vector2
@export var rotation_3d : float
@export var pixel_size := 0.04
@export_enum("BILLBOARD", "UP", "LEFT", "DOWN", "RIGHT") var orientation := "BILLBOARD"

var copy_3d : PlaneSprite3D

func _ready():
	await Observer.floor_ready
	create_3d_copy()

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		if is_instance_valid(copy_3d):
			copy_3d.queue_free()

func create_3d_copy():
	copy_3d = PlaneSprite3D.new()
	copy_3d.pixel_size = pixel_size
	copy_3d.texture = texture
	copy_3d.original_sprite = self
	copy_3d.offset -= offset + offset_3d
	copy_3d.shaded = true
	copy_3d.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	# copy_3d.no_depth_test = true
	match orientation:
		"BILLBOARD":
			copy_3d.billboard_plane = true
		"UP":
			position.y += 0.1
		"LEFT":
			position.x += 0.1
			copy_3d.rotate_y(PI / 2)
		"DOWN":
			position.y -= 0.1
			copy_3d.rotate_y(PI)
		"RIGHT":
			position.x -= 0.1
			copy_3d.rotate_y(-PI / 2)
	Observer.photobooth.add_child(copy_3d)