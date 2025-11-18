extends Node

@export var target_path: Path3D
@export var look_ahead := 5.0
@export var max_speed := 15.0
@export var acceleration := 8.0
@export var brake_distance := 3.0
@export var turn_speed := 2.5
@export var height_offset := 0.5  
@export var max_steer_angle := 0.8
@export var path_update_interval := 0.2
@export var gravity := 9.8  # Gravity strength

# This will be set automatically to the parent if it's a CharacterBody3D
var car: CharacterBody3D = null

var _path_follow: PathFollow3D
var _current_target: Vector3
var _last_path_update := 0.0
var _current_speed := 0.0
var _waypoints: Array[Vector3] = []
var _current_waypoint_index := 0
var _is_active := true
var _vertical_velocity := 0.0  # Track vertical velocity for gravity

func _ready():
	# Get the parent node
	var parent = get_parent()
	
	# Check if parent is a CharacterBody3D
	if parent is CharacterBody3D:
		car = parent
	else:
		# If not, try to find a CharacterBody3D in children
		for child in get_children():
			if child is CharacterBody3D:
				car = child
				break
	
	if not car:
		push_error("AI Car Controller must be a child of a CharacterBody3D or have a CharacterBody3D as a child")
		return
	
	if not target_path:
		push_error("No target_path assigned to AI Car Controller")
		return
	
	# Create a PathFollow3D to follow the path
	_path_follow = PathFollow3D.new()
	target_path.add_child(_path_follow)
	
	# Generate waypoints along the path
	_generate_waypoints()
	
	# Set initial target
	if not _waypoints.is_empty():
		_current_target = _waypoints[0]

func _generate_waypoints():
	_waypoints.clear()
	var curve = target_path.curve
	if not curve:
		push_error("Target path has no curve")
		return
	
	var length = curve.get_baked_length()
	var point_count = max(10, int(length / 2.0))
	
	for i in point_count + 1:
		var offset = (float(i) / point_count) * length
		var point = curve.sample_baked(offset)
		point.y += height_offset  # Simple height offset
		_waypoints.append(target_path.to_global(point))
	
	# Add the first few points at the end for smooth looping
	for i in range(min(5, _waypoints.size())):
		_waypoints.append(_waypoints[i])
	
func _physics_process(delta):
	if not _is_active or _waypoints.is_empty() or not is_instance_valid(car):
		return
	
	# Update path following less frequently for better performance
	_last_path_update += delta
	if _last_path_update >= path_update_interval:
		_last_path_update = 0.0
		_update_path_following()
	
	# Get the direction to the target
	var to_target = _current_target - car.global_transform.origin
	to_target.y = 0  # Ignore vertical difference
	
	# Calculate distance to target
	var distance = to_target.length()
	
	# If we're close to the current waypoint, move to the next one
	if distance < 2.0:  # 2 meter threshold
		_current_waypoint_index = (_current_waypoint_index + 1) % _waypoints.size()
		_current_target = _waypoints[_current_waypoint_index]
		to_target = _current_target - car.global_transform.origin
		to_target.y = 0
		distance = to_target.length()
	
	# Calculate steering
	var forward = car.global_transform.basis.z
	var target_direction = to_target.normalized()
	var angle = forward.signed_angle_to(target_direction, Vector3.UP)
	
	# Apply steering
	var steer_amount = clamp(angle, -max_steer_angle, max_steer_angle)
	car.rotate_y(steer_amount * turn_speed * delta)
	
	# Calculate speed based on distance to target and upcoming turns
	var speed_factor = 1.0
	if distance < brake_distance * 2:
		# Slow down when approaching a waypoint
		speed_factor = (distance / (brake_distance * 2)) * 0.8 + 0.2
	
	# Adjust speed based on the sharpness of the turn
	var turn_factor = 1.0 - (abs(steer_amount) / max_steer_angle * 0.7)
	speed_factor *= turn_factor
	
	# Apply acceleration/deceleration
	var target_speed = max_speed * speed_factor
	_current_speed = move_toward(_current_speed, target_speed, acceleration * delta)
	
	# Calculate horizontal velocity
	var horizontal_velocity = car.global_transform.basis.z * _current_speed
	
	# Apply gravity
	if not car.is_on_floor():
		_vertical_velocity -= gravity * delta
	else:
		_vertical_velocity = 0.0
	
	# Combine horizontal and vertical velocity
	car.velocity = Vector3(horizontal_velocity.x, _vertical_velocity, horizontal_velocity.z)
	
	# Move the car
	car.move_and_slide()
	
	# Keep rotation upright (only rotate on Y axis)
	var current_rotation = car.global_rotation
	car.global_rotation = Vector3(0, current_rotation.y, 0)


func _update_path_following():
	if not _path_follow or _waypoints.is_empty() or not is_instance_valid(car):
		return
	
	# Simple path following - just move along the path
	_path_follow.progress += max_speed * path_update_interval
	
	# Update the current target to a point ahead on the path
	_current_target = _path_follow.global_transform.origin
	_current_target.y = car.global_transform.origin.y 

func set_active(active: bool):
	_is_active = active
	if not active and is_instance_valid(car):
		_current_speed = 0
		_vertical_velocity = 0.0
		car.velocity = Vector3.ZERO

func _exit_tree():
	# Clean up
	if is_instance_valid(_path_follow) and _path_follow.get_parent():
		_path_follow.get_parent().remove_child(_path_follow)
		_path_follow.queue_free()
