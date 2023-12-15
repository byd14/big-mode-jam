extends CheckButton

@export var sfx_switch : AudioStreamPlayer
@export var sounds : Array[AudioStream]

func _on_pressed():
	sfx_switch.stream = sounds.pick_random()
	sfx_switch.play()
