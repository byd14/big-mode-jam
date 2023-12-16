class_name BlackDoor extends StaticBody2D

@export var interactable : InteractableArea2D
@export var sprite : Sprite2D
@export var door_collision : CollisionShape2D
@export var door_3d : PropSprite2D
@export var sfx_closed : AudioStreamPlayer2D
@export var sfx_hit : AudioStream
@export var eye : BlackDoorEye
@export var sfx_error : AudioStream

func _ready():
	if Observer.tutorial_competed:
		open()
	else:
		interactable.on_interact_callback = func ():
			sfx_closed.play()
			if Observer.phil.battery <= 99:
				interactable.text = "Hover over your camera with the mouse.\nGrab handle and crank to recharge battery."
			else:
				interactable.text = "Hold RMB, then adjust focus with A/D.\nTake a shot with LMB."

func open():
	interactable.queue_free()
	sprite.frame = 1
	door_3d.queue_free()
	eye.queue_free()
	door_collision.set_deferred("disabled", true)

func on_photo():
	if is_instance_valid(eye) and eye.focus_difference < Observer.CAMERA_FOCUS_TOLERANCE:
		open()
		AudioManager.play(sfx_hit)
		Observer.create_dialog("Take pictures of the items on your checklist.\nThey say spirits are afraid of cameras...", 300000)