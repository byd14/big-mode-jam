class_name HUDCamera extends Control


@export var battery_status : Sprite2D
@export var camera_body : Node2D
@export var handle_sprite : Sprite2D
@export var film_amount : Label
@export var enter_shape : CollisionShape2D
@export var exit_shape : CollisionShape2D
@export var sfx_break : AudioStreamPlayer
@export var sfx_vision_on : AudioStreamPlayer
@export var sfx_vision_on_dead : AudioStreamPlayer
@export var sfx_vision_off : AudioStreamPlayer
@export var sfx_crank : AudioStreamPlayer
@export var sfx_ready : AudioStreamPlayer
@export var sfx_beep : AudioStreamPlayer
@export var sfx_appear : AudioStreamPlayer
@export var sfx_disappear : AudioStreamPlayer


@export var unfold_offset : float

var target_rot := 0.0
var should_fold := true
var folded := true
var handle_durability := 100.0
var mouse_previous := Vector2()
var toggles : Array[CheckButton]
var phil : Phil
var sfx_crank_delay := 0.1
var sfx_beep_played := true
var sfx_ready_played := true

func _ready():
	Observer.vision_switched.connect(on_vision_change)
	for child in camera_body.get_children():
		if child is CheckButton:
			toggles.push_back(child)
	phil = Observer.floor_scene.phil

func _physics_process(_delta):
	film_amount.text = str(phil.film)
	
	if !folded:
		if handle_durability < 0:
			var count := 0
			for toggle in toggles:
				if toggle.button_pressed:
					count += 1
			if count == toggles.size():
				handle_durability = 100
				if not sfx_ready_played:
					sfx_ready.play()
					sfx_ready_played = true
		if Input.is_action_pressed("camera_photo"):
			if handle_durability > 1:
				var mouse_position := get_viewport().get_mouse_position()
				var anchor := handle_sprite.global_position
				var angle_difference = mouse_position.angle_to_point(anchor) - mouse_previous.angle_to_point(anchor)
				angle_difference = shortest_rotation(angle_difference)
				handle_sprite.rotate(angle_difference)
				mouse_previous = mouse_position
				phil.battery = move_toward(phil.battery, 100, maxf(0, angle_difference * 5))
				if angle_difference > 0:
					if phil.battery < 99:
						handle_durability = maxf(0, handle_durability - pow(angle_difference / PI, 1.5) / 0.05)
						sfx_beep_played = false
					sfx_crank_delay -= angle_difference
					if sfx_crank_delay <= 0:
						sfx_crank.pitch_scale = 1 + (phil.battery / 100) * 0.2
						sfx_crank.play()
						sfx_crank_delay = 0.8
						if phil.battery > 99 and sfx_beep_played == false:
							sfx_beep.play()
							sfx_beep_played = true
							
		else:
			if phil.battery > 1:
				handle_sprite.rotate(-PI / 420)
			if should_fold:
				folded = true
				sfx_disappear.play()
				phil.hud_active -= 1
				enter_shape.set_deferred("disabled", false)
				exit_shape.set_deferred("disabled", true)

		if handle_durability <= 1 and handle_durability >= 0:
			break_handle()

	if phil.battery <= 50:
		battery_status.frame = 0 if sin(Time.get_ticks_msec() / 100.0) > 0 else 1
	elif phil.battery <= 99:
		battery_status.frame = 2
	else:
		battery_status.frame = 3
	
	camera_body.position.y = lerpf(camera_body.position.y, unfold_offset if !folded else 0.0, 0.1)
	

func on_vision_change(vision : bool):
	if !is_inside_tree():
		return
	target_rot += PI
	if vision:
		if phil.battery >= 99:
			sfx_vision_on.play()
		else:
			sfx_vision_on_dead.play()
	else:
		sfx_vision_off.play()

func break_handle():
	handle_durability = -1
	sfx_break.play()
	sfx_ready_played = false
	for toggle in toggles:
		toggles.pick_random().button_pressed = false

func _on_mouse_trigger_mouse_entered():
	if folded:
		phil.hud_active += 1
		sfx_appear.play()
	should_fold = false
	folded = false
	enter_shape.set_deferred("disabled", true)
	exit_shape.set_deferred("disabled", false)

func _on_mouse_trigger_mouse_exited():
	should_fold = true

func shortest_rotation(ang: float) -> float:
	var full_cirlce = 2 * PI
	var new_ang = fmod(ang, full_cirlce)
	if abs(new_ang) > PI:
		if new_ang > 0:
			new_ang -= full_cirlce
		else:
			new_ang += full_cirlce
	return new_ang

func _input(event):
	if event is InputEventMouseButton:
		if !folded and event.is_action_pressed("camera_photo"):
			mouse_previous = get_viewport().get_mouse_position()
			# Removed clicking lowering durability
#			if handle_durability > 0:
#				get_viewport().set_input_as_handled()
#				handle_durability = maxf(0, handle_durability - 10)

