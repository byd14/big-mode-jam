class_name Ghost extends CharacterBody2D

const STUN_TIME := 150
const WALK_NORMAL := 0.36
const WALK_ATTACK := 0.1

@export var sprite : GhostSprite2D
@export var velocity_component : VelocityComponent
@export var light : PointLight2D
@export var animation : AnimatedSprite2D
@export var hitbox : Area2D
@export var sfx_attack : AudioStreamPlayer

var state := normal_state
var hp := 2
var stun := STUN_TIME

func _ready():
	velocity_component.walk_speed = WALK_NORMAL

func _physics_process(_delta):

	light.energy = lerpf(light.energy, 0, 0.02)

	state.call()

	for i in range(5):
		var collision := move_and_collide(velocity_component.step().velocity)
		if !collision:
			break
		velocity_component.process_collision(collision)

func on_photo():
	var distance_normalized = minf(position.distance_to(Observer.floor_scene.phil.position) / 100, 1)
	var focus = absf(Observer.photobooth.operator.focus_slider.value / 100 - sprite.focal_length)
	focus += pow(distance_normalized, 3) * Observer.CAMERA_FOCUS_TOLERANCE
	# if distance_normalized > 1:
	# 	focus += 0.2
	if focus < Observer.CAMERA_FOCUS_TOLERANCE:
		light.energy = 1
		hp -= 1
		state = stun_state
		animation.play("hit")
		velocity_component.stop()
		if hp <= 0:
			queue_free()
			Observer.floor_scene.ghost_count -= 1

func normal_state():
	var phil := Observer.floor_scene.phil
	if hitbox.get_overlapping_bodies().has(phil):
		if animation.animation != "attack":
			sfx_attack.play()
			animation.play("attack")
			velocity_component.stop()
			velocity_component.walk_speed = WALK_ATTACK
	var dir := phil.position - position
	velocity_component.accelerate(dir.normalized())

func stun_state():
	stun -= 1
	if stun <= 0:
		to_idle()
		state = normal_state
		stun = STUN_TIME

func to_idle():
	animation.play("idle")
	velocity_component.walk_speed = WALK_NORMAL

func _on_animated_sprite_2d_animation_finished():
	if animation.animation == "hit":
		animation.play("stun")
	if animation.animation == "attack":
		to_idle()

func _on_animated_sprite_2d_frame_changed():
	if animation.animation == "attack" and animation.frame > 1:
		for body in hitbox.get_overlapping_bodies():
			if body is Phil:
				Observer.call_deferred("death_screen")
