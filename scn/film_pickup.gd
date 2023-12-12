class_name FilmPickup extends Node2D

@export var interactable : InteractableArea2D
@export var sprite : PlaneSprite2D
@export var amount := 3

func _ready():
	add_to_group("Persistent")
	interactable.text = "{amount} FILMS RECIEVED".format({"amount":amount})
	interactable.on_interact_callback = func ():
		Observer.floor_scene.phil.film += amount
		Observer.deleted_nodes.push_back({"level" : Observer.floor_scene.scene_file_path, "name" : name})
		queue_free()
