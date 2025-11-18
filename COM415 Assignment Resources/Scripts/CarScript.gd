extends CharacterBody3D
class_name CarBase

const METERSPORSEC = 3.6

@onready var camera_3d: Camera3D = $Camera3D

@export var speed = 10.0
@export var turn_speed = 0.8
@export var gravity = -20.0
@export var wheel_base = 0.6  # distance between front/rear axles
@export var steering_limit = 10.0  # front wheel max tu$"../WorldEnvironment/Path3D"rning angle (deg)
@export var engine_power = 6.0
@export var braking = -9.0
@export var friction = -2.0
@export var drag = -2.0
@export var max_speed_reverse = 3.0
#Car Mesh Wheels
@export var front_left_wheels : MeshInstance3D
@export var front_right_wheels : MeshInstance3D

# Car state properties
var acceleration = Vector3.ZERO  # current acceleration
var steer_angle = 0.0  # current wheel angle
var target_look
var current_speed: float = 0.0

func _physics_process(delta):
	if is_on_floor():
		get_input()
		apply_friction(delta)
		calculate_steering(delta)
	acceleration.y = gravity
	velocity += acceleration * delta
	move_and_slide()

func apply_friction(delta):
	if velocity.length() < 0.2 and acceleration.length() == 0:
		velocity.x = 0
		velocity.z = 0
	var friction_force = velocity * friction * delta
	var drag_force = velocity * velocity.length() * drag * delta
	acceleration += drag_force + friction_force

func calculate_steering(delta):
	var rear_wheel = transform.origin + transform.basis.z * wheel_base / 2.0
	var front_wheel = transform.origin - transform.basis.z * wheel_base / 2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(transform.basis.y, steer_angle) * delta
	var new_heading = rear_wheel.direction_to(front_wheel)

	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = new_heading * velocity.length()
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	look_at(transform.origin + new_heading, transform.basis.y)

func get_input():
	var turn = Input.get_action_strength("steer_left")
	turn -= Input.get_action_strength("steer_right")
	steer_angle = turn * deg_to_rad(steering_limit)
	front_right_wheels.rotation.y = steer_angle*2
	front_left_wheels.rotation.y = steer_angle*2
	acceleration = Vector3.ZERO
	if Input.is_action_pressed("accelerate"):
		acceleration = -transform.basis.z * engine_power
	if Input.is_action_pressed("brake"):
		acceleration = -transform.basis.z * braking
