class_name ColoredDoor extends StaticBody2D

const GREEN_DOOR := preload("res://assets/doors_new_green.png")
const BLUE_DOOR := preload("res://assets/doors_new_blue.png")

@export_enum("RED", "GREEN", "BLUE") var color := "RED"
@export var interactable : InteractableArea2D
@export var sprite : Sprite2D
@export var door_collision : CollisionShape2D
@export var sfx_closed : AudioStreamPlayer
@export var sfx_open : AudioStreamPlayer

var closed := true

func _ready():
	if color != "RED":
		sprite.texture = GREEN_DOOR if color == "GREEN" else BLUE_DOOR
	if Observer.doors_opened.has(color):
		open()
	else:
		interactable.on_interact_callback = func ():
			if closed:
				if Observer.keys.has(color):
					Observer.doors_opened.push_back(color)
					sfx_open.play()
					interactable.text = "door " + color + " opened"
					open()
				else:
					interactable.text = "need " + color + " key to open"
					sfx_closed.play()

func open():
	interactable.queue_free()
	sprite.frame = 1
	door_collision.set_deferred("disabled", true)