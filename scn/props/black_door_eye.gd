class_name BlackDoorEye extends Node2D

const BLUR_OFFSET := 5

@export var sprite : PlaneSprite2D
@export var blur_copy_1 : PlaneSprite2D
@export var blur_copy_2 : PlaneSprite2D

var original_sprite : GhostSprite2D
var focal_length : float
var focus_difference : float

func _ready():
	focal_length = 0.9

func _physics_process(_delta):
	var distance_normalized = minf(global_position.distance_to(Observer.phil.position) / 100, 1)
	focus_difference = absf(Observer.photobooth.operator.focus_slider.value / 100 - focal_length)
	focus_difference += pow(distance_normalized, 3) * Observer.CAMERA_FOCUS_TOLERANCE
	if focus_difference < Observer.CAMERA_FOCUS_TOLERANCE:
		sprite.modulate.a = 1
	else:
		sprite.modulate.a = 0.25
	blur_copy_1.position.x = focus_difference * BLUR_OFFSET
	blur_copy_2.position.x = -focus_difference * BLUR_OFFSET

	sprite.copy_3d.modulate.a = sprite.modulate.a
	blur_copy_1.copy_3d.modulate.a = sprite.modulate.a
	blur_copy_2.copy_3d.modulate.a = sprite.modulate.a
