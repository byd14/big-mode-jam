class_name IntroSequence extends Control

const TITLE_SCENE = preload("res://scn/title_screen.tscn")

@export var intro_animation : AnimatedSprite2D
@export var dialog_text : Label
@export var boss_sounds : Array[AudioStream]
@export var sfx_outside : AudioStreamPlayer
@export var sfx_inside : AudioStreamPlayer

var loop_counter := 0
var boss_speech_delay := 24
var boss_speech_timer := 60 * 7
var boss_talking := false
var boss_speech := "Hey man, thanks again for accepting the job.\nJust like the email said, get shots of as much stuff from this list as you can and we’ll pay you for what you get!\nTake what you can and get out"

func _ready():
	intro_animation.play("frame1")

func _physics_process(_delta):
	if !boss_talking:
		return
	boss_speech_timer -= 1
	
	boss_speech_delay -= 1
	if boss_speech_delay <= 0:
		AudioManager.play(boss_sounds.pick_random(), -12, randf_range(0.9, 1.1))
		boss_speech_delay = 24 + randi_range(-6, 6)
	
	if boss_speech_timer <= 0:
		boss_talking = false

func _input(event):
	if event.is_action_pressed("interact"):
		if intro_animation.animation == "frame1":
			sfx_outside.stop()
			sfx_inside.play()
			intro_animation.play("frame2a")
			dialog_text.text = ""

		if intro_animation.animation == "frame2c":
			queue_free()
			var title := TITLE_SCENE.instantiate()
			get_tree().root.add_child(title)

func _on_intro_frames_animation_looped():
	if intro_animation.animation == "frame2a":
		loop_counter += 1
		if loop_counter > 1:
			intro_animation.play("frame2transition")

func _on_intro_frames_animation_finished():
	if intro_animation.animation == "frame2a":
		intro_animation.play("frame2transition")
	elif intro_animation.animation == "frame2transition":
		intro_animation.play("frame2b")
		boss_talking = true
		dialog_text.text = boss_speech
	elif intro_animation.animation == "frame2b":
		intro_animation.play("frame2papers")
	elif intro_animation.animation == "frame2papers":
		intro_animation.play("frame2c")
