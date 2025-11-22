extends Control

# Array to store track data
var tracks = [
	{
		"name": "City Tour",
		"preview_image": "res://tracks/previews/city_tour_preview.png",
		"scene_path": "res://COM415 Assignment Resources/Scenes/node.tscn",
		"description": "A Quite Drive",
		"difficulty": "Easy",
		"laps": 3
	},
	{
		"name": "Surbub Tour",
		"preview_image": "res://tracks/previews/suburb_tour_preview.png",
		"scene_path": "res://COM415 Assignment Resources/Scenes/Surbub.tscn",
		"description": "A Thriller",
		"difficulty": "Medium",
		"laps": 4
	}
]

var current_track_index = 0

@onready var track_display = $TrackDisplay
@onready var track_name = $TrackName
@onready var description_label = $DescriptionLabel
@onready var difficulty_label = $DifficultyLabel
@onready var laps_label = $LapsLabel
@onready var btn_prev = $ButtonPrevious
@onready var btn_next = $ButtonNext
@onready var btn_select = $ButtonSelect
@onready var btn_back = $ButtonBack

func _ready():
	update_track_display()
	btn_prev.pressed.connect(_on_previous_pressed)
	btn_next.pressed.connect(_on_next_pressed)
	btn_select.pressed.connect(_on_select_pressed)
	btn_back.pressed.connect(_on_back_pressed)

func update_track_display():
	var track = tracks[current_track_index]
	
	# Load preview image only if it exists in the dictionary
	if track.has("preview_image") and ResourceLoader.exists(track["preview_image"]):
		track_display.texture = load(track["preview_image"])
	else:
		print("No preview image for: ", track["name"])
	
	track_name.text = track["name"]
	description_label.text = track["description"]
	difficulty_label.text = "Difficulty: " + track["difficulty"]
	laps_label.text = "Laps: " + str(track["laps"])

func _on_previous_pressed():
	current_track_index -= 1
	if current_track_index < 0:
		current_track_index = tracks.size() - 1
	update_track_display()

func _on_next_pressed():
	current_track_index += 1
	if current_track_index >= tracks.size():
		current_track_index = 0
	update_track_display()

func _on_select_pressed():
	var selected_track = tracks[current_track_index]
	
	# Store selection in GameManager
	GameManager.selected_track_scene = selected_track["scene_path"]
	GameManager.selected_track_name = selected_track["name"]
	GameManager.selected_track_difficulty = selected_track["difficulty"]
	GameManager.selected_track_laps = selected_track["laps"]
	
	print("Selected Track: ", selected_track["name"])
	
	# Return to main menu
	get_tree().change_scene_to_file("res://menu_scene.tscn")

func _on_back_pressed():
	# Return without selecting
	get_tree().change_scene_to_file("res://menu_scene.tscn")
