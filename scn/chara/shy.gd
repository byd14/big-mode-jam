class_name Shy extends CharacterBody2D

const WALK_NORMAL := 0.32
const WALK_CHASE := 0.96

@export var sprite : GhostSprite2D
@export var velocity_component : VelocityComponent
@export var animation : AnimatedSprite2D
@export var hitbox : Area2D
@export var sfx_scream : AudioStreamPlayer2D

var state := normal_state
var phil : Phil
var clear_sight := false
var current_id_path : Array[Vector2i]
var update_path_timer := 0
var patrol_point : Vector2

func _ready():
	velocity_component.walk_speed = WALK_NORMAL
	animation.play("calm")
	if Observer.floor_is_ready:
		setup()
	else:
		await Observer.floor_ready
		setup()

func setup():
	phil = Observer.floor_scene.phil
	patrol_point = Observer.floor_scene.get_random_empty_point()
	update_current_path()

func _physics_process(_delta):
	if !is_instance_valid(phil):
		return
	
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(position, phil.position, 1)
	query.exclude.push_back(get_rid())
	query.exclude.push_back(phil.get_rid())
	var result = space_state.intersect_ray(query)
	clear_sight = result.is_empty()

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
	if focus < Observer.CAMERA_FOCUS_TOLERANCE:
		queue_free()
		Observer.floor_scene.shy_count -= 1

func normal_state():
	if animation.animation == "scream":
		return

	if clear_sight:
		if phil.vision:
			var forward := Observer.photobooth.operator.transform.basis.z
			var dir := Vector2(forward.x, forward.z).normalized().dot(position.direction_to(phil.position))
			if phil.position.distance_squared_to(position) < pow(200, 2) and dir > 0.6:
				to_chase_state()
		else:
			if phil.position.distance_squared_to(position) < pow(16, 2):
				to_chase_state()

	if current_id_path.is_empty():
		update_current_path()
		return
	
	var target_position := Observer.floor_scene.tilemap.map_to_local(current_id_path.front())
	velocity_component.accelerate(position.direction_to(target_position))
	if position.distance_to(target_position) < 12:
		if position.distance_to(patrol_point) < 32:
			patrol_point = Observer.floor_scene.get_random_empty_point()
			update_current_path()
		current_id_path.pop_front()

func to_chase_state():
	if animation.animation != "scream":
		sfx_scream.play()
		animation.play("scream")
		animation.frame_progress = 1.0
		velocity_component.stop()

func chase_state():
	if !clear_sight:
		update_path_timer -= 1
		if current_id_path.is_empty():
			update_current_path()
			return
		var target_position := Observer.floor_scene.tilemap.map_to_local(current_id_path.front())
		velocity_component.accelerate(position.direction_to(target_position))
		if position.distance_to(target_position) < 12:
			if update_path_timer <= 0:
				update_current_path()
				update_path_timer = 10
			current_id_path.pop_front()
	else:
		for body in hitbox.get_overlapping_bodies():
			if body is Phil:
				animation.play("attack")
		velocity_component.accelerate(position.direction_to(phil.position))
		current_id_path.clear()

func update_current_path():
	var id_path := Observer.floor_scene.get_id_path(position, phil.position if state == chase_state else patrol_point)
	if !id_path.is_empty():
		current_id_path = id_path

func _on_animated_sprite_2d_animation_finished():
	if animation.animation == "scream":
		state = chase_state
		animation.play("idle")
		velocity_component.walk_speed = WALK_CHASE
	if animation.animation == "attack":
		animation.play("idle")

func _on_animated_sprite_2d_frame_changed():
	if animation.animation == "attack" and animation.frame > 1:
		for body in hitbox.get_overlapping_bodies():
			if body is Phil:
				Observer.call_deferred("death_screen")
