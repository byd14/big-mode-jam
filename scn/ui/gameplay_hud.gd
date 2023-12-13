class_name GameplayHUD extends CanvasLayer

const CROSSHAIR := preload("res://assets/ui/crosshair.png")
const HAND := preload("res://assets/ui/hand_cursor.png")

@export var stamina_bar : ProgressBar
@export var vision_overlay : ColorRect
@export var dialog_popup : Control
@export var dialog_label : RichTextLabel
@export var checklist : HUDChecklist
@export var cursor : Sprite2D
@export var hud_notification : Label
@export var hud_camera : HUDCamera

var phil : Phil

func _ready():
	phil = Observer.floor_scene.phil
	Observer.vision_switched.connect(on_vision_switched)
	for goal in Observer.completed_goals:
		var goal_label : Label = checklist.paper.get_node("VBoxContainer/" + goal)
		goal_label.modulate.a = 1
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _physics_process(_delta):
	if phil.hud_active or !checklist.folded:
		cursor.texture = HAND
	else:
		cursor.texture = CROSSHAIR
	stamina_bar.value = phil.stamina
	cursor.position = get_viewport().get_mouse_position().clamp(Vector2.ZERO, vision_overlay.size)
	hud_notification.modulate.a = lerpf(hud_notification.modulate.a, 0, 0.05)
	dialog_popup.modulate.a = lerpf(dialog_popup.modulate.a, 0, 0.04)

func on_vision_switched(new_vision : bool):
	vision_overlay.visible = new_vision

func pop_notification(text : String):
	hud_notification.text = text
	hud_notification.modulate.a = 1
