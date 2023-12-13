class_name Photobooth extends Node3D

var GHOST_COPY_3D := load("res://scn/3dworld/ghost_sprite_3d.tscn")

@export var gridmap : GridMap
@export var operator : Operator
@export var environment : WorldEnvironment
@export var shadow_viewport : SubViewport
@export var shadow_plane : MeshInstance3D
@export var floor_decals : TileMap

func _ready():
	Observer.vision_switched.connect(on_vision_switched)
	var mat : StandardMaterial3D = StandardMaterial3D.new()
	mat.albedo_texture = shadow_viewport.get_texture()
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	shadow_plane.set_surface_override_material(0, mat)
	shadow_plane.visible = true
	if Observer.floor_scene.phil.vision:
		on_vision_switched(true)

func on_vision_switched(new_vision : bool):
	environment.environment.background_color = Color.WEB_GRAY if new_vision else Color.hex(0x080f0b)
