extends AudioStreamPlayer

@export var min_interval := 5.0
@export var max_interval := 15.0

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
		play()
	pass
