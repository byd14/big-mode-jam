class_name GAElevatorEncounter extends GameAction

@export var position : Vector2

func activate():
	if Observer.game_data.has("elevator_power") and Observer.game_data["elevator_power"]:
		if !Observer.game_data.has("elevator_encounter"):
			Observer.game_data["elevator_encounter"] = true
			var i = Observer.floor_scene.GHOST_SCENE.instantiate()
			i.position = position
			Observer.floor_scene.y_sort.call_deferred("add_child", i)