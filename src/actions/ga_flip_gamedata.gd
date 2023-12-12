class_name GAFlipGamedata extends GameAction

@export var keys : Array[String]

func activate():
	for key in keys:
		if Observer.game_data.has(key):
			Observer.game_data[key] = !Observer.game_data[key]
		else:
			Observer.game_data[key] = true
