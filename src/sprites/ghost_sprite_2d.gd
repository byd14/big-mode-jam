class_name GhostSprite2D extends Sprite2D

@export var animation : AnimatedSprite2D
@export var billboard := true
@export var pixel_size := 0.04
@export var offset_3d : Vector2

var focal_length : float
var copy_3d : GhostSprite3D

func _ready():
	focal_length = randf()
	animation.play("idle")
	texture = animation.sprite_frames.get_frame_texture(animation.animation, animation.frame)
	animation.frame_changed.connect(on_frame_change)
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
	copy_3d = Observer.photobooth.GHOST_COPY_3D.instantiate()
	copy_3d.focal_length = focal_length
	copy_3d.original_sprite = self
	copy_3d.main_sprite.texture = texture
	copy_3d.main_sprite.pixel_size = pixel_size
	copy_3d.main_sprite.offset += offset_3d
	copy_3d.billboards = billboard
	Observer.photobooth.add_child(copy_3d)

func on_frame_change():
	texture = animation.sprite_frames.get_frame_texture(animation.animation, animation.frame)
	copy_3d.main_sprite.texture = texture
