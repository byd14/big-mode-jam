class_name GASpawnEnemy extends GameAction

@export_enum("GHOST", "SHY") var enemy_type : String = "GHOST"
@export var position : Vector2
@export var hp_modifier := 1.0

var once := true

func activate():
	if once:
		var i = Observer.floor_scene.GHOST_SCENE.instantiate() if enemy_type == "GHOST" else Observer.floor_scene.SHY_SCENE.instantiate()
		i.position = position
		i.hp *= hp_modifier
		Observer.floor_scene.y_sort.call_deferred("add_child", i)
		once = false
