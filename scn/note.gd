class_name Note extends Node2D

@export var interactable : InteractableArea2D
@export var sprite : PlaneSprite2D
@export var text := "put text here"
@export var actions : Array[GameAction] = []

func _ready():
	add_to_group("Persistent")
	interactable.text = text
	interactable.on_interact_callback = func():
		for action in actions:
			action.activate()
		Observer.deleted_nodes.push_back({"level" : Observer.floor_scene.scene_file_path, "name" : name})
		queue_free()
