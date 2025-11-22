extends Control
@onready var start_button = $VBoxContainer/StartButton
@onready var vehicle_button = $VBoxContainer/VehicleSelectButton
@onready var track_button = $VBoxContainer/TrackSelectButton
@onready var quit_button = $VBoxContainer/QuitButton
@onready var selected_info = $SelectedInfo

var selected_vehicle = null
var selected_track = null

func _ready():
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
			"scene": GameManager.selected_track_scene,
			"difficulty": GameManager.selected_track_difficulty,
			"laps": GameManager.selected_track_laps
		}
	
	update_selection_display()
	check_start_button()

func _on_start_pressed():
	if selected_vehicle != null and selected_track != null:
		# Store selections in GameManager for the race scene to access
		GameManager.selected_car_scene = selected_vehicle.scene
		GameManager.selected_car_name = selected_vehicle.name
		GameManager.selected_car_stats = selected_vehicle.stats if selected_vehicle.has("stats") else {}
		
		GameManager.selected_track_scene = selected_track.scene
		GameManager.selected_track_name = selected_track.name
		GameManager.selected_track_difficulty = selected_track.difficulty if selected_track.has("difficulty") else ""
		GameManager.selected_track_laps = selected_track.laps if selected_track.has("laps") else 3
		
		# Load the selected track scene
		get_tree().change_scene_to_file(selected_track.scene)

func _on_vehicle_select_pressed():
	get_tree().change_scene_to_file("res://Vehicle_Selector.tscn")

func _on_track_select_pressed():
	get_tree().change_scene_to_file("res://track_selector.tscn")

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
		text += "\nTrack: " + selected_track.name + "\n"
		if selected_track.has("difficulty"):
			text += "  Difficulty: " + selected_track.difficulty + "\n"
			text += "  Laps: " + str(selected_track.laps)
	else:
		text += "\nTrack: None"
	
#	selected_info.text = text
func check_start_button():
	pass
	#start_button.disabled = (selected_vehicle == null or selected_track == null)
