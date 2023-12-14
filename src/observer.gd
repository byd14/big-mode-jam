extends Node

signal vision_switched(new_vision : bool)
signal floor_ready

const GROUP_DANGER := "danger"
const CAMERA_VIEW := preload("res://scn/3dworld/camera_view.tscn")
const GAMEPLAY_HUD := preload("res://scn/ui/gameplay_hud.tscn")
const MOUSE_SENS_3D := 0.003
const CAMERA_FOCUS_TOLERANCE := 0.12

var floor_scene : Floor2D
var camera_scene : SubViewportContainer
var hud_scene : GameplayHUD
var photobooth : Photobooth
var phil : Phil

var current_region : CameraRegion
var current_interaction : Control
var floor_is_ready := false

var tutorial_competed := false
var keys : Array = ["RED"]
var doors_opened : Array
var completed_goals : Array
var deleted_nodes : Array

func create_dialog(text : String, time := 120.0):
	hud_scene.dialog_label.modulate.a = time
	hud_scene.dialog_label.text = "[center]" + text

func create_interaction(scene : Control):
	hud_scene.add_child(scene)
	current_interaction = scene

func cancel_interaction():
	if current_interaction != null:
		hud_scene.remove_child(current_interaction)
		current_interaction = null

func checklist_goal_completed(goal : String):
	var goal_label : Label = hud_scene.checklist.paper.get_node("VBoxContainer/" + goal)
	goal_label.modulate.a = 1
	completed_goals.push_back(goal)
	get_viewport().get_texture().get_image().save_jpg("user://" + goal + ".jpg")

func restart_level():
	set_level(load(floor_scene.scene_file_path), false)

func death_screen():
	get_tree().root.remove_child(floor_scene)
	get_tree().root.call_deferred("remove_child", hud_scene)
	get_tree().root.add_child(load("res://scn/ui/death_screen.tscn").instantiate())

func set_level(scene : PackedScene, save := true):
	if save:
		save_game()
	if camera_scene.is_inside_tree():
		photobooth.operator.to_normal_state()
	floor_is_ready = false
	camera_scene.queue_free()
	photobooth.queue_free()
	hud_scene.queue_free()
	floor_scene.queue_free()
	floor_scene = null
	var new_level : Floor2D = scene.instantiate()
	get_tree().root.add_child(new_level)
	load_game()

func delete_nodes():
	for dn in deleted_nodes:
		if dn["level"] != floor_scene.scene_file_path:
			continue
		for pn in get_tree().get_nodes_in_group("Persistent"):
			if pn.name == dn.name and pn.owner.scene_file_path == dn["level"]:
				pn.queue_free()
				break

func save_game():
	var file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	file.store_var({
		"film" : phil.film,
		"deleted_nodes" : deleted_nodes,
		"goals" : completed_goals,
		"keys" : keys,
		"doors" : doors_opened,
		"tutorial" : tutorial_competed	
	})

func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return

	var file = FileAccess.open("user://savegame.save", FileAccess.READ)
	var save_data = file.get_var()

	phil.film = save_data["film"]
	deleted_nodes = save_data["deleted_nodes"]
	completed_goals = save_data["goals"]
	keys = save_data["keys"]
	doors_opened = save_data["doors"]
	tutorial_competed = save_data["tutorial"]