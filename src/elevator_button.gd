class_name ElevatorButton extends Button

@export var floor_number := 1

func _ready():
	text = str(floor_number)
	pressed.connect(on_pressed)

func on_pressed():
	if !Observer.game_data.has("elevator_power") or Observer.game_data["elevator_power"] == false:
		return
	match floor_number:
		1:
			Observer.set_level(load("res://flr/test_floor.tscn"))
		2:
			Observer.set_level(load("res://flr/floor_1.tscn"))