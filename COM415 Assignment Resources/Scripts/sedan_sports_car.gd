extends CharacterBody3D

#@onready var wheel_front_right = $"wheel-front-right"
#@onready var wheel_front_left = $"wheel-front-left"

@export var gravity = 140.0


@export var speed = 10.0
@export var turn_speed = 0.8

func _physics_process(delta):
	velocity.y -= gravity * delta
	get_input(delta)
	move_and_slide()
	

func get_input(delta):
	var vy = velocity.y
	velocity = Vector3.ZERO
	var move = Input.get_axis("accelerate", "brake")
	var turn = Input.get_axis("steer_right", "steer_left")
	velocity += -transform.basis.z * move * speed
	rotate_y(turn_speed * turn * delta)
	velocity.y = vy
