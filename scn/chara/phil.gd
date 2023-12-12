class_name Phil extends CharacterBody2D

const WALK_NORMAL = 0.65
const WALK_SLOW = WALK_NORMAL * 0.4
const WALK_FAST = WALK_NORMAL * 1.85
const STEP_DELAY := 40

@export var velocity_component : VelocityComponent
@export var sprite : AnimatedSprite2D
@export var light : UnstableLight2D
@export var interact_area : Area2D
@export var camera_hitbox : Area2D
@export var sfx_danger : AudioStreamPlayer
@export var sfx_step : AudioStreamPlayer2D
@export var step_sounds : Array[AudioStream]
@export var film := 5

var state : Callable = normal_state
var mouse_pos : Vector2
var input := Vector2()
var vision := false
var stamina := 100.0
var stamina_degen : = 0.75
var stamina_regen := 0.15
var sprint := false
var exhausted := false
var x_facing := 1
var battery := 100.0
var battery_degen := 0.0
var battery_degen_nv := 0.0
var hud_active := 0

func _ready():
	velocity_component.walk_speed = WALK_NORMAL

func gather_input():
	input.x = Input.get_axis("left", "right")
	input.y = Input.get_axis("up", "down")
	input = input.normalized()
	mouse_pos = get_global_mouse_position()

	match state:
		normal_state:
			if Input.is_action_just_pressed("interact"):
				for area in interact_area.get_overlapping_areas():
					if area is InteractableArea2D:
						if area.dialog:
							switch_state(dialog_state)
						area.on_interact()
						break
			if Input.is_action_just_pressed("camera_scope"):
				switch_state(camera_state)
				to_camera_state()
		dialog_state:
			if Input.is_action_just_pressed("interact"):
				Observer.cancel_interaction()
				switch_state(normal_state)


func _physics_process(_delta):
	gather_input()

	update_stamina()
	update_battery()

	sfx_danger.volume_db = -45 + (1 - light.normalized_distance) * 50
	
	state.call()

	for i in range(5):
		var collision := move_and_collide(velocity_component.step().velocity)
		if !collision:
			break
		velocity_component.process_collision(collision)

	animation_state()


func switch_state(new_state : Callable):
	if new_state == dialog_state:
		hud_active += 1
	elif state == dialog_state:
		hud_active -= 1
	velocity_component.stop()
	sprint = false
	state = new_state

func normal_state():
	if Input.is_action_pressed("sprint") and !exhausted and hud_active == 0:
		if stamina < 1:
			sprint = false
			exhausted = true
		else:
			sprint = true
	else:
		sprint = false

	velocity_component.walk_speed = WALK_NORMAL
	if sprint:
		velocity_component.walk_speed = WALK_FAST
	if hud_active > 0:
		velocity_component.walk_speed = WALK_SLOW

	if input.length_squared() == 0:
		velocity_component.decelerate()
	else:
		if input.x != 0:
			x_facing = sign(input.x)
		velocity_component.accelerate(input)

	sprite.scale.x = x_facing

func dialog_state():
	pass

func camera_state():
	pass

func to_camera_state():
	switch_vision(true)
	var rot = (get_global_mouse_position() - position).angle()
	Observer.current_region.camera.enabled = false
	Observer.floor_scene.visible = false
	get_tree().root.add_child(Observer.camera_scene)
	Observer.photobooth.operator.position.x = position.x / 32
	Observer.photobooth.operator.position.z = (position.y - 5) / 32
	Observer.photobooth.operator.rotation.y = - (rot + PI / 2)
	Observer.photobooth.operator.rotation.x = 0
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func update_battery():
	var delta := battery_degen_nv if vision else battery_degen
	battery = maxf(battery - delta, 0)
	if battery < 1 and vision:
		switch_vision(false)

func update_stamina():
	if sprint:
		stamina = maxf(stamina - stamina_degen, 0)
	else:
		stamina = minf(stamina + stamina_regen, 100)
		if stamina > 10 and exhausted:
			exhausted = false

func switch_vision(new_vision : bool):
	vision = new_vision
	Observer.vision_switched.emit(new_vision)

func _on_camera_hitbox_area_entered(area:Area2D):
	if area is PhotoSensative:
		area.on_photo()
		if area.has_node("ChecklistGoal"):
			Observer.checklist_goal_completed(area.get_node("ChecklistGoal").goal_name)

func animation_state():
	var anim = "idle"
	if state == normal_state:
		if input.x != 0 or input.y != 0:
			if sprint:
				anim = "run_"
			else:
				anim = "walk_"

			if input.x != 0:
				anim += "side"
			else:
				anim += "up" if input.y < 0 else "down"
	sprite.play(anim)


# Footstep stuff
func _on_animated_sprite_2d_frame_changed():
	# I'm sure there's a more concise way to do this, but it works and isn't *too* crazy
	if ("walk" in sprite.animation and (sprite.frame == 1 or sprite.frame == 3)) or ("run" in sprite.animation and (sprite.frame == 3 or sprite.frame == 7)):
		footstep_sound()

func _on_animated_sprite_2d_animation_changed():
	if sprite.animation == "idle":
		footstep_sound()

func footstep_sound():
	sfx_step.stream = step_sounds.pick_random()
	sfx_step.pitch_scale = randf_range(0.9, 1.1)
	sfx_step.play()
