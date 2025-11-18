extends Control
@onready var start_button = $VBoxContainer/StartButton
@onready var vehicle_button = $VBoxContainer/VehicleSelectButton
@onready var track_button = $VBoxContainer/TrackSelectButton
@onready var quit_button = $VBoxContainer/QuitButton
@onready var selected_info = $SelectedInfo

var selected_vehicle = null
var selected_track = null

func _ready():
	# Check if returning from vehicle selection
	if GameManager.selected_car_name != "":
		selected_vehicle = {
			"name": GameManager.selected_car_name,
			"scene": GameManager.selected_car_scene,
			"stats": GameManager.selected_car_stats
		}
	
	# Check if returning from track selection
	if GameManager.selected_track_name != "":
		selected_track = {
			"name": GameManager.selected_track_name,
			"scene": GameManager.selected_track_scene
		}
	
	update_selection_display()
	check_start_button()

func _on_start_pressed():
	if selected_vehicle != null and selected_track != null:
		get_tree().change_scene_to_file("res://scenes/race.tscn")

func _on_vehicle_select_pressed():
	get_tree().change_scene_to_file("res://COM415 Assignment Resources/Resources/carSelectors.tscn")

func _on_track_select_pressed():
	get_tree().change_scene_to_file("res://COM415 Assignment Resources/Resources/track_menu.tscn")

func _on_quit_pressed():
	get_tree().quit()

func update_selection_display():
	var text = "Current Selection:\n\n"
	
	if selected_vehicle:
		text += "Vehicle: " + selected_vehicle.name + "\n"
		if selected_vehicle.has("stats"):
			text += "  Speed: " + str(selected_vehicle.stats.speed) + "\n"
			text += "  Handling: " + str(selected_vehicle.stats.handling) + "\n"
	else:
		text += "Vehicle: None\n"
	
	if selected_track:
		text += "\nTrack: " + selected_track.name
	else:
		text += "\nTrack: None"
	
	selected_info.text = text

func check_start_button():
	start_button.disabled = (selected_vehicle == null or selected_track == null)
