class_name EndScreen extends Control

@export var photos_container : HBoxContainer
@export var cursor : Sprite2D

func _ready():
	for goal in Observer.completed_goals:
		var i := TextureRect.new()
		var image := Image.new()
		image.load("user://" + goal + ".jpg")
		var photo_texture := ImageTexture.create_from_image(image)
		photo_texture.set_size_override(Vector2i(960, 768) / 5)
		i.texture = photo_texture
		photos_container.add_child(i)

func _physics_process(_delta):
	cursor.position = get_viewport().get_mouse_position()
