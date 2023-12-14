class_name GhostSprite3D extends Sprite3D

const BLUR_OFFSET := 1

@export var blur_copy_1 : Sprite3D
@export var blur_copy_2 : Sprite3D

var original_sprite : GhostSprite2D
var focal_length : float

func _ready():
	blur_copy_1.texture = original_sprite.texture
	blur_copy_2.texture = original_sprite.texture

func _physics_process(_delta):
	blur_copy_1.texture = texture
	blur_copy_2.texture = texture
	var distance_normalized = minf(original_sprite.global_position.distance_to(Observer.phil.position) / 100, 1)
	var focus_difference = absf(Observer.photobooth.operator.focus_slider.value / 100 - focal_length)
	focus_difference += pow(distance_normalized, 3) * Observer.CAMERA_FOCUS_TOLERANCE
	if focus_difference < Observer.CAMERA_FOCUS_TOLERANCE:
		modulate.a = 1
	else:
		modulate.a = 0.25
	blur_copy_1.position.x = focus_difference * BLUR_OFFSET
	blur_copy_2.position.x = -focus_difference * BLUR_OFFSET

	var camera_pos = Observer.photobooth.operator.position
	camera_pos.y = 0
	look_at(camera_pos, Vector3(0, 1, 0))

	follow()

func follow():
	var position_3d := original_sprite.global_position / 32
	position.x = position_3d.x
	position.z = position_3d.y
