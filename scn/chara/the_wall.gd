class_name TheWall extends StaticBody2D

const LIFETIME = 60 * 40

@export var sprite : PlaneSprite2D
@export var animation : AnimatedSprite2D

var timer := LIFETIME

func _ready():
	timer += randi_range(7, 15) * 60 
	animation.play("idle")
	sprite.texture = animation.sprite_frames.get_frame_texture(animation.animation, animation.frame)

func _physics_process(_delta):
	timer -= 1
	if timer <= 0:
		sprite.modulate.a = lerpf(sprite.modulate.a, 0, 0.03)
		sprite.copy_3d.modulate.a = sprite.modulate.a
		if sprite.modulate.a < 0.01:
			move()
	else:
		sprite.modulate.a = lerpf(sprite.modulate.a, 1, 0.03)
		sprite.copy_3d.modulate.a = sprite.modulate.a
		

func on_photo():
	timer = 0

func move():
	var old := position
	position = Observer.floor_scene.wall_points.pick_random()
	Observer.floor_scene.wall_points.erase(position)
	Observer.floor_scene.wall_points.push_back(old)
	timer = LIFETIME

func _on_animated_sprite_2d_frame_changed():
	sprite.texture = animation.sprite_frames.get_frame_texture(animation.animation, animation.frame)
	if sprite.copy_3d:
		sprite.copy_3d.texture = sprite.texture
