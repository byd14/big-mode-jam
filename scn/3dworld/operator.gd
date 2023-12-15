class_name Operator extends Camera3D

@export var light : Light3D
@export var animation_player : AnimationPlayer
@export var focus_slider : HSlider
@export var sfx_photo : AudioStream
@export var sfx_error : AudioStreamPlayer
@export var sfx_error_sounds : Array[AudioStream]

var mouse_sensitivity : float
var phil : Phil
var input_active := false

func _ready():
	mouse_sensitivity = Observer.MOUSE_SENS_3D
	phil = Observer.floor_scene.phil

func _physics_process(_delta):
	light.visible = phil.light.enabled
	if phil.camera_hitbox.monitoring:
		phil.camera_hitbox.monitoring = false
	if Input.is_action_just_pressed("camera_photo"):
		if animation_player.current_animation == "" and phil.battery >= 99 and phil.film > 0:
			AudioManager.play(sfx_photo)
			phil.battery = 0
			phil.film -= 1
			phil.camera_hitbox.monitoring = true
			animation_player.call_deferred("play", "camera_flash")
			phil.camera_hitbox.rotation = -rotation.y - PI / 2
		else:
			if phil.battery < 99:
				Observer.hud_scene.pop_notification("out of battery")
			if phil.film <= 0:
				Observer.hud_scene.pop_notification("out of film")
			sfx_error.stream = sfx_error_sounds.pick_random()
			sfx_error.play()

	if Input.is_action_just_released("camera_scope"):
		to_normal_state()

	if Input.is_action_just_pressed("focus_left") or Input.is_action_just_pressed("focus_right"):
		input_active = true

	if input_active:
		var focus_input := Input.get_axis("focus_left", "focus_right")
		focus_slider.value += focus_input / 0.9

func _input(event):
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * mouse_sensitivity
		rotation.x = clampf(rotation.x - event.relative.y * mouse_sensitivity, -PI / 2, PI / 2)

func to_normal_state():
	Observer.current_region.camera.enabled = true
	animation_player.play("RESET")
	input_active = false
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	Observer.floor_scene.visible = true
	get_tree().root.remove_child(Observer.camera_scene)
	phil.switch_state(phil.normal_state)
	phil.switch_vision(false)
	phil.camera_hitbox.monitoring = false
