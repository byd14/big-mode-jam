class_name EndScreen extends Control

const PHOTO_CARD_SCENE = preload("res://scn/ui/photo_card.tscn")

@export var photos_container : HBoxContainer
@export var cursor : Sprite2D

func _ready():
	for goal in Observer.completed_goals:
		var i : PhotoCard = PHOTO_CARD_SCENE.instantiate()
		var image := Image.new()
		image.load("user://" + goal + ".jpg")
		var photo_texture := ImageTexture.create_from_image(image)
		photo_texture.set_size_override(Vector2i(960, 768) / 7)
		i.photo_image.texture = photo_texture
		i.photo_label.text = goal
		photos_container.add_child(i)

func _physics_process(_delta):
	cursor.position = get_viewport().get_mouse_position()
