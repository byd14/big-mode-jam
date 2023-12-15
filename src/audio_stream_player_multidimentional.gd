class_name AudioStreamPlayerMultidimetional extends AudioStreamPlayer2D

var copy_3d : AudioStreamPlayer3D

func _ready():
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
	copy_3d.max_distance = max_distance
	copy_3d.volume_db = volume_db
	copy_3d.pitch_scale = pitch_scale
	Observer.photobooth.add_child(copy_3d)
	copy_3d.tree_entered.connect(sync_sounds)

func sync_sounds():
	copy_3d.play(get_playback_position())