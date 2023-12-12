class_name Fingers extends Node2D

@export var line : Line2D
@export var sprite : Sprite2D
@export var photo_sensative : PhotoSensative
@export var hitbox : Area2D

var astar_grid : AStarGrid2D
var phil : Phil
var tilemap : TileMap
var current_id_path : Array[Vector2i]
var update_path_timer := 0
var state : Callable
var prev_target := Vector2(0, 0)
var should_remove := false
var line_3d_copy : Line2D

func _ready():
	await owner.ready

	line_3d_copy = Line2D.new()
	line_3d_copy.width = line.width
	line_3d_copy.width_curve = line.width_curve
	line_3d_copy.default_color = line.default_color
	line_3d_copy.gradient = line.gradient
	line_3d_copy.points = line.points
	line_3d_copy.position = global_position
	Observer.photobooth.shadow_viewport.add_child(line_3d_copy)

	sprite.copy_3d.visible = false

	tilemap = Observer.floor_scene.tilemap
	phil = Observer.floor_scene.phil
	astar_grid = AStarGrid2D.new()
	astar_grid.region = tilemap.get_used_rect()
	astar_grid.cell_size = Vector2i(32, 32)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	astar_grid.update()

	for cell in tilemap.get_used_cells(0):
		astar_grid.set_point_solid(cell)

	update_current_path()
	photo_sensative.on_photo_callback = to_retract_state

	state = normal_state

func update_current_path():
	var id_path := astar_grid.get_id_path(tilemap.local_to_map(sprite.global_position), tilemap.local_to_map(phil.position))
	if !id_path.is_empty():
		current_id_path = id_path

func _physics_process(_delta):
	state.call()
	if Observer.photobooth.is_inside_tree():
		line_3d_copy.points = line.points

func normal_state():
	if position.distance_to(phil.position) > 32 * 5:
		state = to_retract_state
		return

	update_path_timer -= 1

	
	var target_position : Vector2
	if current_id_path.is_empty():
		target_position = phil.position
		if update_path_timer <= 0:
			update_current_path()
			current_id_path.pop_front()
			update_path_timer = 10
	else:
		target_position = tilemap.map_to_local(current_id_path.front())

	sprite.global_position = sprite.global_position.move_toward(target_position, 0.5)
	sprite.look_at(target_position)

	line.set_point_position(line.get_point_count() - 1, sprite.position)

	if sprite.global_position == target_position:
		if update_path_timer <= 0:
			update_current_path()
			update_path_timer = 10
		current_id_path.pop_front()
		if current_id_path:
			if should_remove:
				line.remove_point(line.get_point_count() - 1)
				should_remove = false
			var next_point := tilemap.map_to_local(current_id_path.front())
			if line.get_point_count() > 1 and next_point == line.points[line.get_point_count() - 2] + position:
				should_remove = true
			else: 
				var point : Vector2 = target_position - position
				line.add_point(point)
			
func chase_state():
	if position.distance_to(phil.position) < 32 * 5:
		state = normal_state

func retract_state():
	line.set_point_position(line.get_point_count() - 1, sprite.position)
	var point := line.points[line.get_point_count() - 2] + position
	sprite.global_position = sprite.global_position.move_toward(point, 1.7)
	if sprite.global_position == point:
		if line.get_point_count() - 3 > -1:
			sprite.look_at(line.points[line.get_point_count() - 3] + position)
			sprite.rotate(PI)
		line.remove_point(line.get_point_count() - 1)
		if line.get_point_count() == 0:
			update_current_path()
			state = chase_state
			for body in hitbox.get_overlapping_bodies():
				if body is Phil:
					Observer.call_deferred("death_screen")
			line.add_point(Vector2(0, 0))

func to_retract_state():
	state = retract_state


func _on_hitbox_body_entered(body:Node2D):
	if body is Phil:
		if state != retract_state:
			Observer.call_deferred("death_screen")