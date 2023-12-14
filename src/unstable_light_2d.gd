class_name UnstableLight2D extends PointLight2D

const MASK_SHADER := preload("res://src/shaders/mask.gdshader")
const RADIAL_MASK := preload("res://assets/radial_gradient_alpha.tres")

@export var base_flicker := 0.989
@export var maximum_distance := 180
@export var present_in_3d := false

var mask : Sprite2D
var normalized_distance := 1.0
var copy_3d : OmniLight3D

func _ready():
	visible = false
	if Observer.floor_is_ready:
		create_mask()
	else: 
		await Observer.floor_ready
		create_mask()

func _physics_process(_delta):
	mask.global_position = global_position
	mask.visible = enabled
	var closest := INF
	for node in get_tree().get_nodes_in_group(Observer.GROUP_DANGER):
		var distance := (node as Node2D).global_position.distance_to(global_position)
		if distance < maximum_distance and distance < closest:
			closest = distance
	if closest < INF:
		normalized_distance = closest / maximum_distance
	else:
		normalized_distance = 1

	if present_in_3d:
		copy_3d.visible = enabled

	enabled = randf() < base_flicker - (1 - normalized_distance) * 0.45

func create_mask():
	mask = Sprite2D.new()
	mask.global_position = global_position
	mask.texture = RADIAL_MASK
	mask.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	mask.scale.x = texture_scale
	mask.scale.y = texture_scale
	mask.material = ShaderMaterial.new()
	(mask.material as ShaderMaterial).shader = MASK_SHADER
	Observer.floor_scene.darkness_buffer.add_child(mask)
	if present_in_3d:
		copy_3d = OmniLight3D.new()
		copy_3d.position.x = global_position.x / 32
		copy_3d.position.z = (global_position.y - position.y) / 32
		copy_3d.position.y = 1.3
		Observer.photobooth.add_child(copy_3d)