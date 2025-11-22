extends CharacterBody3D

@export var gravity = 140.0
@export var speed = 10.0
@export var turn_speed = 0.8

var camera_follow: Camera3D

func _ready():
	# Find or create camera follow script
	var camera = find_child("Camera3D")
	if camera:
		camera_follow = camera
		# Attach camera follow script if not already attached
		if not camera.has_meta("camera_follow_attached"):
			camera.script = load("res://camera_follow.gd")
			camera.follow_target = self
			camera.current = true
			camera.set_meta("camera_follow_attached", true)

func _physics_process(delta):
	velocity.y -= gravity * delta
	get_input(delta)
	move_and_slide()

func get_input(delta):
	var vy = velocity.y
	velocity = Vector3.ZERO
	
	# Get input from keyboard/touch actions and joystick
	var move = Input.get_axis("accelerate", "brake")
	var turn = Input.get_axis("steer_right", "steer_left")
	
	# Clamp move to -1 to 1 range
	move = clamp(move, -1.0, 1.0)
	turn = clamp(turn, -1.0, 1.0)
	
	velocity += -transform.basis.z * move * speed
	rotate_y(turn_speed * turn * delta)
	velocity.y = vy
