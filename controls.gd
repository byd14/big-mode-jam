extends Control

func _input(event):
	if event.is_action_pressed("interact"):
		queue_free()
		var i = load("res://scn/intro.tscn").instantiate()
		get_tree().root.add_child(i)
