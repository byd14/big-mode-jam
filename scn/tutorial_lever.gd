class_name TutorialLever extends Node2D

@export var sprite : PlaneSprite2D
@export var interactable : InteractableArea2D
@export var actions : Array[GameAction] = []

var active = false

func _ready():
	interactable.on_interact_callback = func ():
		active = !active
		for action in actions:
			action.activate()
		sprite.flip_v = !sprite.flip_v