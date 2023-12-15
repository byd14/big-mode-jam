class_name PhotoCard extends Control

@export var photo_image : TextureRect
@export var photo_label : Label
@export var root : Control

var ogriginal_size : Vector2
var expand := false

func _ready():
	ogriginal_size = custom_minimum_size
	root.rotation = randf_range(-0.1, 0.1)

func _physics_process(_delta):
	root.scale = root.scale.lerp(Vector2(1.4, 1.4) if expand else Vector2.ONE, 0.15)
	z_index = 0
	if expand:
		z_index = 1

func _on_mouse_trigger_mouse_exited():
	expand = false

func _on_mouse_trigger_mouse_entered():
	expand = true
