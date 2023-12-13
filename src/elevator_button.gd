class_name ElevatorButton extends Button

@export var floor_number := 1

func _ready():
	text = str(floor_number)
	pressed.connect(on_pressed)

func on_pressed():
	if Observer.floor_scene.scene_file_path == "res://flr/entry_floor.tscn":
		Observer.tutorial_competed = true
	match floor_number:
		1:
			Observer.set_level(load("res://flr/entry_floor.tscn"))
		2:
			Observer.set_level(load("res://flr/floor_1.tscn"))