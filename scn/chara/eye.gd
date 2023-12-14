class_name Eye extends CharacterBody2D

const WALK_NORMAL := 1.3

@export var sprite : PlaneSprite2D
@export var velocity_component : VelocityComponent
@export var animation : AnimatedSprite2D
@export var hitbox : Area2D

var state := normal_state
var follow_target : Node2D

func _ready():
	velocity_component.walk_speed = WALK_NORMAL
	animation.play("idle")

func _physics_process(_delta):
	if !is_instance_valid(follow_target):
		if get_tree().get_nodes_in_group(Observer.GROUP_DANGER).is_empty():
			velocity_component.stop()
			return
		follow_target = get_tree().get_nodes_in_group(Observer.GROUP_DANGER).pick_random()

	state.call()

	for i in range(5):
		var collision := move_and_collide(velocity_component.step().velocity)
		if !collision:
			break
		velocity_component.process_collision(collision)

func on_photo():
	Observer.hud_scene.hud_camera.break_handle()
	animation.play("hurt")
	velocity_component.stop()

func normal_state():
	var target_position := follow_target.position + follow_target.position.direction_to(Observer.phil.position) * 46
	if animation.animation == "hurt":
		velocity_component.decelerate()
		return

	velocity_component.move = ((target_position - position) / 100).limit_length(WALK_NORMAL)
	

func _on_animated_sprite_2d_animation_finished():
	if animation.animation == "hurt":
		animation.play("idle")

func _on_animated_sprite_2d_frame_changed():
	sprite.texture = animation.sprite_frames.get_frame_texture(animation.animation, animation.frame)
	if sprite.copy_3d:
		sprite.copy_3d.texture = sprite.texture
