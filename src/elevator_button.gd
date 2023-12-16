class_name ElevatorButton extends Button

var F1 := load("res://flr/entry_floor.tscn")
var F2 := load("res://flr/floor_1.tscn")
var F3 := load("res://flr/floor_2.tscn")
var F4 := load("res://flr/floor_3.tscn")

@export var floor_number := 1
@export var sfx : AudioStream

func _ready():
	# text = str(floor_number)
	pressed.connect(on_pressed)

func on_pressed():
	Observer.tutorial_competed = true
	match floor_number:
		1:
			Observer.elevator_screen(F1)
		2:
			Observer.elevator_screen(F2)
		3:
			Observer.elevator_screen(F3)
		4:
			Observer.elevator_screen(F4)
	
	AudioManager.play(sfx, 1, 1, "UI")
