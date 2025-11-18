extends Control

@onready var track_list = $VBoxContainer/TrackList
@onready var back_button = $VBoxContainer/BackButton
@onready var select_button = $VBoxContainer/SelectButton
@onready var description_label = $VBoxContainer/DescriptionLabel

var tracks = [
	{"name": "City Tour", "scene": "res://COM415 Assignment Resources/Scenes/node.tscn", "description": "A Quite Drive"},
	{"name": "Surbub Tour", "scene": "res://COM415 Assignment Resources/Scenes/Surbub.tscn", "description": "A Thriller"},

]

var selected_track_index = 0

func _ready():
	# Populate the track list
	for track in tracks:
		track_list.add_item(track["name"])
	
	# Select first track by default
	track_list.select(0)
	_update_description()

func _on_track_selected(index: int):
	selected_track_index = index
	_update_description()

func _update_description():
	var track = tracks[selected_track_index]
	description_label.text = track["description"]

func _on_select_pressed():
	var track = tracks[selected_track_index]
	GameManager.selected_track_name = track["name"]
	GameManager.selected_track_scene = track["scene"]
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
