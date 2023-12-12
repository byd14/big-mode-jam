extends CheckButton

@export var sfx_switch : AudioStreamPlayer

func _on_pressed():
	sfx_switch.play()