extends AudioStreamPlayer2D

@export var min_interval := 7.0
@export var max_interval := 25.0
@export var sounds : Array[AudioStream]
@export var play_sporadically := true

var interval
var timer := 0.0
var player # You need to bind on entered area for this to work
var base_volume


# Called when the node enters the scene tree for the first time.
func _ready():
	interval = randf_range(min_interval, max_interval)
	base_volume = volume_db


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if play_sporadically:
		timer += delta
		if timer > interval:
			timer = 0.0
			interval = randf_range(min_interval, max_interval)
			stream = sounds.pick_random()
			play()
	
	if player:
		print ("player")
		var attenuated_volume = remap((global_position - player.global_position).length(), 10, 400, base_volume, base_volume -36)
		if attenuated_volume <= -45:
			volume_db = -99
		else:
			volume_db = attenuated_volume
	

func _on_area_2d_area_entered(area):
	if area.is_in_group("interact_area"):
		player = area
