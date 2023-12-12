class_name HUDChecklist extends Control

@export var paper : Sprite2D
@export var unfold_offset := 256
@export var sfx_appear : AudioStreamPlayer
@export var sfx_disappear : AudioStreamPlayer

var folded := true

func _physics_process(_delta):
	paper.position.y = lerpf(paper.position.y, 0 if folded else -unfold_offset, 0.1)

func _on_mouse_trigger_mouse_entered():
	folded = false
	sfx_appear.play()

func _on_mouse_trigger_mouse_exited():
	folded = true
	sfx_disappear.play()
