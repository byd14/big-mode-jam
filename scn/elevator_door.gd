class_name ElevatorDoor extends StaticBody2D

@export var music : MultidimensionalAudioPlayer

func _ready():
	music.play(Time.get_ticks_msec() / 1000.0)
