extends Control

@onready var selected_info = $CenterContainer/VBoxContainer/SelectedInfo

func _ready():
	# Make sure global script is loaded as autoload
	if not get_node_or_null("/root/Global"):
		var global_script = preload("res://global.gd").new()
		get_node("/root").add_child(global_script)
		global_script.name = "Global"
	
	update_selected_info()

func update_selected_info():
	var global = get_node("/root/Global")
	var vehicle = global.vehicles[global.selected_vehicle]
	var track = global.tracks[global.selected_track]
	selected_info.text = "Selected: %s on %s" % [vehicle.name, track.name]

func _on_start_button_pressed():
	# Start the game with selected vehicle and track
	var global = get_node("/root/Global")
	global.start_game()

func _on_vehicle_select_button_pressed():
	# Switch to vehicle selection screen
	get_tree().change_scene_to_file("res://vehicle_select.tscn")

func _on_track_select_button_pressed():
	# Switch to track selection screen
	get_tree().change_scene_to_file("res://track_selection.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
