class_name TitleScreen extends Control

@export var building : AnimatedSprite2D
@export var to_start : Label

func _input(event):
	if event.is_action_pressed("interact") and to_start.modulate.a == 1.0:
		queue_free()
		get_tree().root.add_child(load("res://flr/entry_floor.tscn").instantiate())

func _on_animation_player_animation_finished(_anim_name:StringName):
	building.play("loop")
	to_start.modulate.a = 1.0
