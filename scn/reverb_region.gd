extends Area2D

@export var reverb_wet := 0.2
@export var reverb_size := 0.3
@export var reverb_delay := 60
@export var reverb_damping := 0.5


func _on_area_entered(area):
	if area.is_in_group("interact_area"):

		var reverb := AudioServer.get_bus_effect(1, 0)
		reverb.wet = reverb_wet
		reverb.room_size = reverb_size
		reverb.damping = reverb_damping
		reverb.predelay_msec = reverb_delay
