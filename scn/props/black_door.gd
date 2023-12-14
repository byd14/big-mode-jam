class_name BlackDoor extends StaticBody2D

@export var interactable : InteractableArea2D
@export var sprite : Sprite2D
@export var door_collision : CollisionShape2D
@export var door_3d : PropSprite2D
@export var sfx_closed : AudioStreamPlayer2D
@export var eye : BlackDoorEye

func _ready():
	if Observer.tutorial_competed:
		open()
	else:
		interactable.on_interact_callback = func ():
			sfx_closed.play()
			if Observer.phil.battery <= 99:
				interactable.text = "hover bottom left corner with mouse\n grab handle and rotate to recharge battery"
			else:
				interactable.text = "hold RMB, then adjust focus with A/D\n and take a shot with LMB press"

func open():
	interactable.queue_free()
	sprite.frame = 1
	door_3d.queue_free()
	eye.queue_free()
	door_collision.set_deferred("disabled", true)

func on_photo():
	if is_instance_valid(eye) and eye.focus_difference < Observer.CAMERA_FOCUS_TOLERANCE:
		open()
