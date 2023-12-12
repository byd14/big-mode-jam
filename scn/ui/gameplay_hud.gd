class_name GameplayHUD extends CanvasLayer

@export var stamina_bar : ProgressBar
@export var vision_overlay : ColorRect
@export var film_amount : Label
@export var dialog_popup : Control
@export var dialog_label : Label
@export var checklist : HUDChecklist

var phil : Phil

func _ready():
	phil = Observer.floor_scene.phil
	Observer.vision_switched.connect(on_vision_switched)
	for goal in Observer.completed_goals:
		var goal_label : Label = checklist.paper.get_node("VBoxContainer/" + goal)
		goal_label.modulate.a = 1

func _physics_process(_delta):
	stamina_bar.value = phil.stamina
	film_amount.text = "film: {film}".format({"film": phil.film})

func on_vision_switched(new_vision : bool):
	vision_overlay.visible = new_vision
