@tool
class_name CameraRegion extends Area2D

@export_range(10, 99) var width : int
@export_range(8, 99) var height : int
@export var collision_shape : CollisionShape2D
@export var camera : Camera2D

@export var enter_actions : Array[GameAction] = [] 

var phil : Phil

func _ready():
	if !Engine.is_editor_hint():
		var rect = (collision_shape.shape as RectangleShape2D)
		rect.size.x = width * 32
		rect.size.y = height * 32
		camera.limit_top = int(position.y - height * 16)
		camera.limit_left = int(position.x - width * 16)
		camera.limit_bottom = int(position.y + height * 16)
		camera.limit_right = int(position.x + width * 16)

func _process(_delta):
	if Engine.is_editor_hint(): 
		var rect = (collision_shape.shape as RectangleShape2D)
		rect.size.x = width * 32
		rect.size.y = height * 32

func _physics_process(_delta):
	if !Engine.is_editor_hint():
		if camera.enabled:
			camera.global_position = phil.position


func _on_body_entered(body):
	if body is Phil:
		if is_instance_valid(Observer.current_region):
			Observer.current_region.camera.enabled = false
		camera.enabled = true
		phil = body
		Observer.current_region = self
		for action in enter_actions:
			action.activate()
