class_name KeyPickup extends Node2D

const GREEN_KEY := preload("res://assets/key_green.png")
const BLUE_KEY := preload("res://assets/key_blue.png")

@export_enum("RED", "GREEN", "BLUE") var color := "RED"
@export var sound : AudioStream
@export var interactable : InteractableArea2D
@export var sprite : Sprite2D

func _ready():
	if Observer.keys.has(color):
		queue_free()
		return

	if color != "RED":
		sprite.texture = GREEN_KEY if color == "GREEN" else BLUE_KEY

	interactable.on_interact_callback = func():
		AudioManager.play(sound, -9)
		Observer.keys.push_back(color)
		interactable.text = "acquired " + color + " key"
		queue_free()