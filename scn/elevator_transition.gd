class_name ElevatorTransition extends Control

@export var sprite : AnimatedSprite2D
@export var music : AudioStreamPlayer

var next_level : PackedScene

func _ready():
	sprite.play("default")
	music.play(Time.get_ticks_msec() / 1000.0)

func _on_animation_player_animation_finished(_anim_name):
	Observer.set_level(next_level)
	music.stop()
	queue_free()
