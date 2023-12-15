class_name InteractableArea2D extends Area2D

@export var text := "yo!"
@export var dialog := true
@export var interaction_scene : Control
@export var time := 120.0
@export var sfx : Array[AudioStream]
@export var sfx_bus := "UI"
var on_interact_callback := func(): print("interaction")

func _ready():
	if interaction_scene:
		interaction_scene.visible = visible
		interaction_scene.get_parent().call_deferred("remove_child", interaction_scene)

func on_interact():
	on_interact_callback.call()
	if interaction_scene != null:
		Observer.create_interaction(interaction_scene)
	if dialog:
		Observer.create_dialog(text, time)
		
	if not sfx.is_empty():
			AudioManager.play(sfx.pick_random(), 1, 1, sfx_bus)

func _notification(what):
	if what == NOTIFICATION_PREDELETE and is_instance_valid(interaction_scene):
		interaction_scene.queue_free()
