class_name VelocityComponent extends Node

@export var accel : float = 0.2
@export var decel : float = 0.4
@export var drag : float = 0.2

var velocity := Vector2()
var move := Vector2()
var bump := Vector2()
var walk_speed : float = 4

func _ready():
    set_process(false)

func accelerate(dir : Vector2) -> VelocityComponent:
    move = move.move_toward(dir * walk_speed, accel)
    return self

func decelerate() -> VelocityComponent:
    move = move.move_toward(Vector2.ZERO, decel)
    return self

func push(strength : Vector2) -> VelocityComponent:
    bump += strength
    return self

func step() -> VelocityComponent:
    bump = bump.lerp(Vector2.ZERO, drag)
    velocity = move + bump
    return self

func set_move_and_bump(val : Vector2) -> VelocityComponent:
    bump = val
    move = val
    return self

func set_move_and_bump_x(val : float) -> VelocityComponent:
    bump.x = val
    move.x = val
    return self

func set_move_and_bump_y(val : float) -> VelocityComponent:
    bump.y = val
    move.y = val
    return self

func stop() -> VelocityComponent:
    bump = Vector2.ZERO
    move = Vector2.ZERO
    return self

func process_collision(col : KinematicCollision2D) -> VelocityComponent:
    var n := col.get_normal()
    move = move.slide(n)
    bump = bump.slide(n)
    return self