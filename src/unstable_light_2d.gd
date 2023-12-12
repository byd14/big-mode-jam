class_name UnstableLight2D extends PointLight2D

@export var base_flicker := 0.989
@export var maximum_distance := 180

var normalized_distance := 1.0

func _physics_process(_delta):
	var closest := INF
	for node in get_tree().get_nodes_in_group(Observer.GROUP_DANGER):
		var distance := (node as Node2D).global_position.distance_to(global_position)
		if distance < maximum_distance and distance < closest:
			closest = distance
	if closest < INF:
		normalized_distance = closest / maximum_distance
	else:
		normalized_distance = 1

	enabled = randf() < base_flicker - (1 - normalized_distance) * 0.45