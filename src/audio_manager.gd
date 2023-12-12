extends Node

func play(sound : AudioStream, volume := 0, pitch := 1.0) -> AudioStreamPlayer:
	var i := AudioStreamPlayer.new()
	i.stream = sound
	i.volume_db = volume
	i.pitch_scale = pitch
	i.finished.connect(free_player.bind(i))
	add_child(i)
	i.play()
	return i

func play_2d(sound : AudioStream, position : Vector2, volume := 0, pitch := 1.0) -> AudioStreamPlayer2D:
	var i := AudioStreamPlayer2D.new()
	i.stream = sound
	i.volume_db = volume
	i.pitch_scale = pitch
	i.global_position = position
	i.finished.connect(free_player.bind(i))
	add_child(i)
	i.play()
	return i

func free_player(player : AudioStreamPlayer):
	player.queue_free()
