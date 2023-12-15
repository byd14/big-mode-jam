class_name IntroSequence extends Control

@export var intro_animation : AnimatedSprite2D
var loop_counter := 0

func _ready():
	intro_animation.play("frame1")

func _input(event):
	if event.is_action_pressed("interact"):
		if intro_animation.animation == "frame1":
			intro_animation.play("frame2a")

func _on_intro_frames_animation_looped():
	if intro_animation.animation == "frame2a":
		loop_counter += 1
		if loop_counter > 1:
			intro_animation.play("frame2transition")

func _on_intro_frames_animation_finished():
	if intro_animation.animation == "frame2transition":
		intro_animation.play("frame2b")

