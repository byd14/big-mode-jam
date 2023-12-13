class_name TheWall extends StaticBody2D

const LIFETIME = 60 * 50

@export var sprite : PlaneSprite2D
@export var animation : AnimatedSprite2D

var timer := LIFETIME

func _ready():
	animation.play("idle")
	sprite.texture = animation.sprite_frames.get_frame_texture(animation.animation, animation.frame)

func _physics_process(_delta):
	timer -= 1
	if timer <= 0:
		move()

func on_photo():
	move()

func move():
	var old := position
	position = Observer.floor_scene.wall_points.pick_random()
	Observer.floor_scene.wall_points.erase(position)
	Observer.floor_scene.wall_points.push_back(old)

func _on_animated_sprite_2d_frame_changed():
	sprite.texture = animation.sprite_frames.get_frame_texture(animation.animation, animation.frame)
	if sprite.copy_3d:
		sprite.copy_3d.texture = sprite.texture
