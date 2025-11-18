# car_selector.gd
extends Node3D

@onready var car_display = $CarDisplay
@onready var car_manager = $CarManager

var current_car_instance = null

func _ready():
	load_car(car_manager.get_current_car())

func load_car(car_path):
	# Remove current car if exists
	if current_car_instance:
		current_car_instance.queue_free()
	
	# Load and instance new car
	var car_scene = load(car_path)
	if car_scene:
		current_car_instance = car_scene.instantiate()
		car_display.add_child(current_car_instance)
		
		# Center the car
		current_car_instance.position = Vector3.ZERO
		current_car_instance.rotation_degrees = Vector3(0, 180, 0)  # Make it face the camera

func _on_next_pressed():
	load_car(car_manager.next_car())

func _on_prev_pressed():
	load_car(car_manager.previous_car())
