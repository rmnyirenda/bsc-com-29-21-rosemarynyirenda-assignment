extends Control

@onready var start_button = $VBoxContainer/StartButton
@onready var vehicle_button = $VBoxContainer/VehicleSelectButton
@onready var track_button = $VBoxContainer/TrackSelectButton
@onready var quit_button = $VBoxContainer/QuitButton
@onready var selected_info = $SelectedInfo

var selected_vehicle = null
var selected_track = null

func _ready():
	start_button.pressed.connect(_on_start_pressed)
	vehicle_button.pressed.connect(_on_vehicle_select_pressed)
	track_button.pressed.connect(_on_track_select_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
	update_selection_display()
	check_start_button()

func _on_start_pressed():
	if selected_vehicle != null and selected_track != null:
		pass
		#GameManager.start_race(selected_vehicle, selected_track)
		#get_tree().change_scene_to_file("res://scenes/race.tscn")

func _on_vehicle_select_pressed():
	pass
	#get_tree().change_scene_to_file("res://scenes/vehicle_select.tscn")

func _on_track_select_pressed():
	pass
	#get_tree().change_scene_to_file("res://scenes/track_select.tscn")

func _on_quit_pressed():
	get_tree().quit()

func update_selection_display():
	var text = "Current Selection:\n"
	if selected_vehicle:
		text += "Vehicle: " + selected_vehicle.name + "\n"
	if selected_track:
		text += "Track: " + selected_track.name
	selected_info.text = text

func check_start_button():
	start_button.disabled = (selected_vehicle == null or selected_track == null)
