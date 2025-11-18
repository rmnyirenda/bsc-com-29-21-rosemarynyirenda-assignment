extends Node

# Variables to store selected car info
var selected_car_scene: String = ""
var selected_car_name: String = ""
var selected_car_stats: Dictionary = {}
var selected_track_name = ""
var selected_track_scene = ""

# Function to get the actual car instance
func get_selected_car_instance() -> Node:
	if selected_car_scene != "":
		return load(selected_car_scene).instantiate()
	return null
