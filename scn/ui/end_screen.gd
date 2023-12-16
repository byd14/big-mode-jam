class_name EndScreen extends Control

const PHOTO_CARD_SCENE = preload("res://scn/ui/photo_card.tscn")

@export var photos_container : HBoxContainer
@export var cursor : Sprite2D
@export var end_result : Label

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

	var ending : String

	match Observer.completed_goals.size():
		0:
			ending = "Nothing?! Find your own ride home, pal."
		1, 2:
			ending = "That’s it? Don’t bother calling us back!"
		3, 4:
			ending = "Not bad! You’ve earned this $5."
		5:
			ending = "WOW!! This special is going to be a HIT. Maybe you are OcculTV material after all!"

	end_result.text = ending

	if Input.is_action_just_pressed("ui_cancel"):
		print("adddd")
		get_tree().quit()

func _physics_process(_delta):
	cursor.position = get_viewport().get_mouse_position()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
