extends Control
class_name RaceHUD


@onready var speed_label: Label = $MarginContainer/VBoxContainer/SpeedLabel
@onready var lap_label: Label = $MarginContainer/VBoxContainer/LapLabel
@onready var position_label: Label = $MarginContainer/VBoxContainer/PositionLabel
@onready var race_end_panel: Panel = $RaceEndPanel
@onready var final_position_label: Label = $RaceEndPanel/VBoxContainer/PositionLabel
@onready var final_time_label: Label = $RaceEndPanel/VBoxContainer/TimeLabel
@onready var replay_button: Button = $RaceEndPanel/VBoxContainer/ReplayButton
@onready var menu_button: Button = $RaceEndPanel/VBoxContainer/MenuButton


@export var player_car: CharacterBody3D
@export var race_manager: RaceManager

const METERS_PER_SECOND_TO_KPH = 3.6

func _ready():
	# Hide the race end panel at start
	if race_end_panel:
		race_end_panel.visible = false
	

func _process(_delta):
	if player_car and race_manager:
		_update_speed()
		_update_lap_info()
		_update_position()

func _update_speed():
	if not player_car:
		return
	
	# Calculate speed from velocity
	var velocity = player_car.velocity
	var speed_ms = sqrt(velocity.x * velocity.x + velocity.z * velocity.z)
	var speed_kph = speed_ms * METERS_PER_SECOND_TO_KPH
	
	if speed_label:
		speed_label.text = "Speed: %d km/h" % int(speed_kph)

func _update_lap_info():
	if not race_manager:
		return
	
	var current_lap = race_manager.get_current_lap("Player")
	var total_laps = race_manager.total_laps
	
	print("Current Lap: %d, Total Laps: %d, Race Started: %s" % [current_lap, total_laps, race_manager.race_started])
	
	if lap_label:
		if current_lap > total_laps:
			lap_label.text = "Race Finished!"

		else:
			lap_label.text = "Lap: %d/%d" % [current_lap, total_laps]

func _update_position():
	if not race_manager:
		return
	
	var current_pos = race_manager.get_racer_position("Player")
	
	if position_label:
		var suffix = _get_position_suffix(current_pos)
		position_label.text = "Position: %d%s" % [current_pos, suffix]

func _get_position_suffix(race_pos: int) -> String:
	# Returns "st", "nd", "rd", or "th" based on position
	if race_pos % 10 == 1 and race_pos != 11:
		return "st"
	elif race_pos % 10 == 2 and race_pos != 12:
		return "nd"
	elif race_pos % 10 == 3 and race_pos != 13:
		return "rd"
	else:
		return "th"

func _on_lap_completed(racer_name: String, lap_number: int, lap_time: float):
	# This is called when any racer completes a lap
	if racer_name == "Player":
		print("Lap %d completed in %.2f seconds!" % [lap_number, lap_time])

func _on_race_finished(racer_name: String, final_pos: int, total_time: float):
	# This is called when any racer finishes the race
	if racer_name == "Player":
		_show_race_end_screen(final_pos, total_time)

func _show_race_end_screen(final_pos: int, total_time: float):
	# Show the race end panel
	if race_end_panel:
		race_end_panel.visible = true
	
	# Display final position
	if final_position_label:
		var suffix = _get_position_suffix(final_pos)
		final_position_label.text = "You finished in %d%s place!" % [final_pos, suffix]
	
	# Display total time in minutes:seconds format
	if final_time_label:
		var minutes = int(total_time / 60)
		var seconds = total_time - (minutes * 60)
		final_time_label.text = "Total Time: %d:%05.2f" % [minutes, seconds]
	
	# Disable player car input
	if player_car and player_car.has_method("set_active"):
		player_car.set_active(false)

func _on_replay_pressed():
	# Reset the race and reload the scene
	if race_manager:
		race_manager.reset_race()
	get_tree().reload_current_scene()

func _on_menu_pressed():
	# Return to main menu
	# CHANGE THIS PATH to match your main menu scene
	get_tree().change_scene_to_file("res://main_menu.tscn")
