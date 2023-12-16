class_name TheWall extends StaticBody2D

const LIFETIME = 60 * 40

@export var sprite : GhostSprite2D
@export var sfx_death : AudioStreamPlayer2D

var timer := LIFETIME

func _ready():
	timer += randi_range(7, 15) * 60 
	sprite.visible = true

func _physics_process(_delta):
	timer -= 1
	if timer <= 0:
		sprite.modulate.a = lerpf(sprite.modulate.a, 0, 0.03)
		sprite.copy_3d.main_sprite.modulate.a = sprite.modulate.a
		if sprite.modulate.a < 0.01:
			move()
	else:
		sprite.modulate.a = lerpf(sprite.modulate.a, 1, 0.03)
		sprite.copy_3d.main_sprite.modulate.a = sprite.modulate.a

func on_photo():
	var distance_normalized = minf(position.distance_to(Observer.floor_scene.phil.position) / 100, 1)
	var focus = absf(Observer.photobooth.operator.focus_slider.value / 100 - sprite.focal_length)
	focus += pow(distance_normalized, 3) * Observer.CAMERA_FOCUS_TOLERANCE
	if focus < Observer.CAMERA_FOCUS_TOLERANCE:
		queue_free()
		Observer.floor_scene.shy_count -= 1
		timer = 0
		sfx_death.play()

func move():
	var old := position
	position = Observer.floor_scene.wall_points.pick_random()
	Observer.floor_scene.wall_points.erase(position)
	Observer.floor_scene.wall_points.push_back(old)
	timer = LIFETIME
