extends Camera3D

@export var follow_target: Node3D
@export var distance_behind: float = 10.0
@export var height_above: float = 3.75
@export var look_ahead: float = 5.0
@export var smoothing: float = 0.1

var target_position: Vector3
var target_look_at: Vector3

func _ready():
	# If no target is set, try to find the player car
	if not follow_target:
		follow_target = get_parent()
	
	if follow_target:
		update_camera_position()

func _process(delta):
	if not follow_target or not is_instance_valid(follow_target):
		return
	
	update_camera_position()

func update_camera_position():
	if not follow_target:
		return
	
	# Get the direction the car is facing
	var car_forward = -follow_target.global_transform.basis.z
	var car_right = follow_target.global_transform.basis.x
	var car_up = follow_target.global_transform.basis.y
	
	# Calculate camera position behind and above the car
	target_position = follow_target.global_position
	target_position += car_forward * distance_behind
	target_position += car_up * height_above
	
	# Calculate look-at point ahead of the car
	target_look_at = follow_target.global_position
	target_look_at += car_forward * look_ahead
	target_look_at += car_up * 1.0
	
	# Smoothly move camera to target position
	global_position = global_position.lerp(target_position, smoothing)
	
	# Look at the target point
	look_at(target_look_at, Vector3.UP)
