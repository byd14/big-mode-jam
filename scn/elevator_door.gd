class_name ElevatorDoor extends StaticBody2D

@export var interactable : InteractableArea2D

func _ready():
	interactable.on_interact_callback = func ():
		if Observer.game_data.has("elevator_power") and Observer.game_data["elevator_power"]:
			interactable.text = "choose floor"
