class_name Floor2D extends Node2D

const GHOST_SCENE := preload("res://scn/chara/ghost.tscn")
const SHY_SCENE := preload("res://scn/chara/shy.tscn")

@export var darkness_buffer : BackBufferCopy
@export var tilemap : TileMap
@export var floor_decals : TileMap
@export var phil : Phil
@export var y_sort : Node2D
@export var start_region : CameraRegion

@export var ghost_count_total := 0
@export var shy_count_total := 0

var floor_started := false
var ghost_count := 0
var shy_count := 0
var ghost_spawn_timer := 0
var shy_spawn_timer := 0

var astar_grid : AStarGrid2D
var empty_cells : Array[Vector2i]
var persitant_nodes : Array[Node]

func _ready():
	Observer.floor_scene = self
	Observer.camera_scene = Observer.CAMERA_VIEW.instantiate()
	Observer.hud_scene = Observer.GAMEPLAY_HUD.instantiate()
	Observer.phil = phil

	darkness_buffer.rect = Rect2(Vector2.ZERO, tilemap.get_used_rect().size * tilemap.cell_quadrant_size)

	get_tree().root.call_deferred("add_child", Observer.hud_scene)

	Observer.photobooth = Observer.camera_scene.get_node("SubViewport/Photobooth")
	var gridmap := Observer.photobooth.gridmap

	astar_grid = AStarGrid2D.new()
	astar_grid.region = tilemap.get_used_rect()
	astar_grid.cell_size = Vector2i(32, 32)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	astar_grid.update()

	for cell_x in tilemap.get_used_rect().size.x:
		for cell_y in tilemap.get_used_rect().size.y:
			empty_cells.push_back(Vector2i(cell_x, cell_y))

	for cell in tilemap.get_used_cells(0):
		gridmap.set_cell_item(Vector3i(cell.x, 0, cell.y), 0)
		astar_grid.set_point_solid(cell)
		empty_cells.erase(cell)


	var floor_decals_3d := Observer.photobooth.floor_decals
	for cell in floor_decals.get_used_cells(0):
		floor_decals_3d.set_cell(0, cell, floor_decals.get_cell_source_id(0, cell), floor_decals.get_cell_atlas_coords(0, cell))

	Observer.floor_is_ready = true
	Observer.floor_ready.emit()
	Observer.call_deferred("delete_nodes")

	if start_region:
		start_region.body_exited.connect(start_floor)

	set_physics_process(false)

func _physics_process(_delta):
	if ghost_count < ghost_count_total:
		ghost_spawn_timer -= 1
		if ghost_spawn_timer <= 0:
			spawn_ghost()
	if shy_count < shy_count_total:
		shy_spawn_timer -= 1
		if shy_spawn_timer <= 0:
			spawn_shy()

func get_id_path(from : Vector2, to : Vector2) -> Array[Vector2i]:
	return astar_grid.get_id_path(tilemap.local_to_map(from), tilemap.local_to_map(to))

func get_random_empty_point() -> Vector2:
	var point := tilemap.map_to_local(empty_cells.pick_random())
	while point.distance_squared_to(phil.position) < (300 * 300):
		point = tilemap.map_to_local(empty_cells.pick_random())
	return point

func start_floor(body : PhysicsBody2D):
	if !(body is Phil) or floor_started:
		return
	print("boo")
	for ghost in ghost_count_total:
		spawn_ghost()
	for shy in shy_count_total:
		spawn_shy()
	set_physics_process(true)
	floor_started = true

func spawn_ghost():
	var i = GHOST_SCENE.instantiate()
	i.position = get_random_empty_point()
	y_sort.call_deferred("add_child", i)
	ghost_count += 1
	ghost_spawn_timer = 60 * 48
	print("ghost")

func spawn_shy():
	var i = SHY_SCENE.instantiate()
	i.position = get_random_empty_point()
	y_sort.call_deferred("add_child", i)
	shy_count += 1
	shy_spawn_timer = 60 * 48
	print("shy")
