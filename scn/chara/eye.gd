class_name Eye extends CharacterBody2D

const WALK_NORMAL := 0.97

@export var sprite : PlaneSprite2D
@export var velocity_component : VelocityComponent
@export var animation : AnimatedSprite2D
@export var hitbox : Area2D

var state := normal_state
var current_id_path : Array[Vector2i]
var update_path_timer := 0
var follow_target : Node2D

func _ready():
	velocity_component.walk_speed = WALK_NORMAL
	animation.play("idle")
	if Observer.floor_is_ready:
		setup()
	else:
		await Observer.floor_ready
		setup()

func setup():
	pass
	# follow_target = get_tree().get_nodes_in_group(Observer.GROUP_DANGER).pick_random()
	# update_current_path()

func _physics_process(_delta):
	if !is_instance_valid(follow_target):
		if get_tree().get_nodes_in_group(Observer.GROUP_DANGER).is_empty():
			return
		follow_target = get_tree().get_nodes_in_group(Observer.GROUP_DANGER).pick_random()
		update_current_path()

	state.call()

	for i in range(5):
		var collision := move_and_collide(velocity_component.step().velocity)
		if !collision:
			break
		velocity_component.process_collision(collision)

func on_photo():
	if animation.animation != "hurt":
		Observer.hud_scene.hud_camera.break_handle()
		animation.play("hurt")
		velocity_component.stop()

func normal_state():
	if animation.animation == "hurt" or position.distance_squared_to(follow_target.position) < pow(42, 2):
		velocity_component.decelerate()
		return
	if current_id_path.is_empty() or update_path_timer <= 0:
		update_current_path()
		update_path_timer = 10
	else:
		var target_position := Observer.floor_scene.tilemap.map_to_local(current_id_path.front())
		velocity_component.accelerate(position.direction_to(target_position))
		if position.distance_to(target_position) < 12:
			current_id_path.pop_front()

func update_current_path():
	if Observer.floor_scene.astar_grid.is_point_solid(Observer.floor_scene.tilemap.local_to_map(follow_target.position)):
		velocity_component.stop()
	var id_path := Observer.floor_scene.get_id_path(position, follow_target.position)
	if !id_path.is_empty():
		current_id_path = id_path

func _on_animated_sprite_2d_animation_finished():
	if animation.animation == "hurt":
		animation.play("idle")

func _on_animated_sprite_2d_frame_changed():
	sprite.texture = animation.sprite_frames.get_frame_texture(animation.animation, animation.frame)
	if sprite.copy_3d:
		sprite.copy_3d.texture = sprite.texture
