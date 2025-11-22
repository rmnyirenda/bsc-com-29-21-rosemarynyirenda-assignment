extends Node3D

@export var player_car_scene: PackedScene
@export var spawn_position: Vector3 = Vector3(0, 1, 0)
@export var spawn_rotation: Vector3 = Vector3(0, 0, 0)

var player_car: CharacterBody3D
var camera_follow: Camera3D

func _ready():
	# Get player car scene from GameManager if not set
	if not player_car_scene and GameManager.selected_car_scene != "":
		player_car_scene = load(GameManager.selected_car_scene)
	
	if player_car_scene:
		spawn_player_car()
	else:
		push_error("No player car scene available")

func spawn_player_car():
	# Instantiate the player car
	player_car = player_car_scene.instantiate()
	if not player_car:
		push_error("Failed to instantiate player car")
		return
	
	# Add to scene
	add_child(player_car)
	
	# Set position and rotation
	player_car.global_position = spawn_position
	player_car.global_rotation = spawn_rotation
	
	# Attach camera follow script to the camera
	var camera = player_car.find_child("Camera3D")
	if camera:
		camera.script = load("res://camera_follow.gd")
		camera.follow_target = player_car
		camera.current = true
	
	print("Player car spawned at: ", spawn_position)
