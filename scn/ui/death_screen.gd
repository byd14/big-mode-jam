class_name DeathScreen extends Control

func _input(event):
	if event.is_action_pressed("interact"):
		Observer.restart_level()
		queue_free()