# car_manager.gd
extends Node

# Array to store car scene paths
var car_scenes = [
	"res://path_to_car1.tscn",
	"res://path_to_car2.tscn",
	"res://path_to_car3.tscn"
]
var current_car_index = 0

func get_current_car():
	return car_scenes[current_car_index]

func next_car():
	current_car_index = (current_car_index + 1) % car_scenes.size()
	return get_current_car()

func previous_car():
	current_car_index = (current_car_index - 1) % car_scenes.size()
	if current_car_index < 0:
		current_car_index = car_scenes.size() - 1
	return get_current_car()

func instantiate_car() -> Node:
	var car_path = get_current_car()
	var car_scene = load(car_path)
	if car_scene:
		return car_scene.instantiate()
	return null
