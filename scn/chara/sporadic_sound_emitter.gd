extends AudioStreamPlayer2D

@export var min_interval := 7.0
@export var max_interval := 25.0
@export var sounds : Array[AudioStream]

var interval
var timer := 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	interval = randf_range(min_interval, max_interval)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	if timer > interval:
		timer = 0.0
		interval = randf_range(min_interval, max_interval)
		stream = sounds.pick_random()
		play()
		print ("i'm making a noise!")
	pass
