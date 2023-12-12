class_name GameplayHUD extends CanvasLayer

const CROSSHAIR := preload("res://assets/ui/crosshair.png")
const HAND := preload("res://assets/ui/hand_cursor.png")

@export var stamina_bar : ProgressBar
@export var vision_overlay : ColorRect
@export var film_amount : Label
@export var dialog_popup : Control
@export var dialog_label : Label
@export var checklist : HUDChecklist
@export var cursor : Sprite2D

var phil : Phil

func _ready():
	phil = Observer.floor_scene.phil
	Observer.vision_switched.connect(on_vision_switched)
	for goal in Observer.completed_goals:
		var goal_label : Label = checklist.paper.get_node("VBoxContainer/" + goal)
		goal_label.modulate.a = 1
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _physics_process(_delta):
	if phil.hud_active:
		cursor.texture = HAND
	else:
		cursor.texture = CROSSHAIR
	stamina_bar.value = phil.stamina
	film_amount.text = "film: {film}".format({"film": phil.film})
	cursor.position = get_viewport().get_mouse_position()

func on_vision_switched(new_vision : bool):
	# pass
	vision_overlay.visible = new_vision
