class_name ElevatorButton extends Button

@export var floor_number := 1
@export var sfx : AudioStream

func _ready():
	text = str(floor_number)
	pressed.connect(on_pressed)

func on_pressed():
	Observer.tutorial_competed = true
	match floor_number:
		1:
			Observer.set_level(load("res://flr/entry_floor.tscn"))
		2:
			Observer.set_level(load("res://flr/floor_1.tscn"))
		3:
			Observer.set_level(load("res://flr/floor_2.tscn"))
		4:
			Observer.set_level(load("res://flr/floor_3.tscn"))
	
	AudioManager.play(sfx, 1, 1, "UI")
