class_name GASetGamedata extends GameAction

@export var data : Dictionary

func activate():
	for key in data:
		Observer.game_data[key] = data[key]
