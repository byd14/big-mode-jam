extends AudioStreamPlayer2D
class_name MultidimensionalAudioPlayer

@export var min_interval := 7.0
@export var max_interval := 25.0
@export var sounds : Array[AudioStream]
@export var play_sporadically := true

var interval
var timer := 0.0
var player # You need to bind on entered area for this to work
var base_volume

var copy_3d : AudioStreamPlayer3D

func _ready():
	interval = randf_range(min_interval, max_interval)
	base_volume = volume_db
	
	if Observer.floor_is_ready:
		create_3d_copy()
	else:
		await Observer.floor_ready
		create_3d_copy()

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		if is_instance_valid(copy_3d):
			copy_3d.queue_free()

func play_both(from_position : float = 0.0):
	play(from_position)
	copy_3d.play(from_position)

func create_3d_copy():
	copy_3d = AudioStreamPlayer3D.new()
	copy_3d.unit_size = 0.8
	var position_3d := global_position / 32
	copy_3d.position.x = position_3d.x
	copy_3d.position.z = position_3d.y
	copy_3d.position.y = 1
	copy_3d.autoplay = autoplay
	copy_3d.stream = stream
	copy_3d.bus = bus
	copy_3d.max_distance = max_distance + 250
	copy_3d.volume_db = volume_db + 3
	copy_3d.pitch_scale = pitch_scale
	Observer.photobooth.add_child(copy_3d)
	copy_3d.tree_entered.connect(sync_sounds)

func sync_sounds():
	copy_3d.play(get_playback_position())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if play_sporadically:
		timer += delta
		if timer > interval:
			timer = 0.0
			interval = randf_range(min_interval, max_interval)
			if !sounds.is_empty():
				stream = sounds.pick_random()
			play()
	
	if player:
		var attenuated_volume = remap((global_position - player.global_position).length(), 10, max_distance, base_volume, base_volume -36)
		if attenuated_volume <= -45:
			volume_db = -99
		else:
			volume_db = attenuated_volume
	

func _on_area_2d_area_entered(area): # THIS IS PROBABLY NOT AN ACCEPTABLE SOLUTION, I'M JUST A DUMBASS LMAO. FEEL FREE TO FIX
	if area.is_in_group("interact_area"):
		player = area
