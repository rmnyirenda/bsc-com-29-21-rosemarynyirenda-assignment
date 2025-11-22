extends Node

# Car variables
var selected_car_scene: String = ""
var selected_car_name: String = ""
var selected_car_stats: Dictionary = {}

# Track variables
var selected_track_scene: String = ""
var selected_track_name: String = ""
var selected_track_difficulty: String = ""
var selected_track_laps: int = 0

# Function to get the actual car instance
func get_selected_car_instance() -> Node:
	if selected_car_scene != "":
		return load(selected_car_scene).instantiate()
	return null

# Function to get the actual track instance
func get_selected_track_instance() -> Node:
	if selected_track_scene != "":
		return load(selected_track_scene).instantiate()
	return null

# Function to check if both selections are made
func is_ready_to_race() -> bool:
	return selected_car_name != "" and selected_track_name != ""

# Function to clear selections
func clear_selections():
	selected_car_scene = ""
	selected_car_name = ""
	selected_car_stats = {}
	selected_track_scene = ""
	selected_track_name = ""
	selected_track_difficulty = ""
	selected_track_laps = 0
