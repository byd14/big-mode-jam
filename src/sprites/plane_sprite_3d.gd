class_name PlaneSprite3D extends Sprite3D

var original_sprite : Sprite2D
var billboard_plane := false

func _physics_process(_delta):
	if billboard_plane:
		var camera_pos = Observer.photobooth.operator.position
		camera_pos.y = 0
		look_at(camera_pos, Vector3(0, 1, 0))
		rotate_y(PI)
	follow()

func follow():
	var position_3d := original_sprite.global_position / 32
	position.x = position_3d.x
	position.z = position_3d.y
