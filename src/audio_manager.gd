extends Node

func play(sound : AudioStream) -> AudioStreamPlayer:
	var i := AudioStreamPlayer.new()
	i.stream = sound
	i.finished.connect(free_player.bind(i))
	add_child(i)
	i.play()
	return i

func play_2d(sound : AudioStream, position : Vector2) -> AudioStreamPlayer2D:
	var i := AudioStreamPlayer2D.new()
	i.global_position = position
	i.stream = sound
	i.finished.connect(free_player.bind(i))
	add_child(i)
	i.play()
	return i

func free_player(player : AudioStreamPlayer):
	player.queue_free()
