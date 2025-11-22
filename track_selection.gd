extends Control

@onready var track_texture = $CenterContainer/VBoxContainer/HBoxContainer/TrackTexture
@onready var track_name = $CenterContainer/VBoxContainer/TrackName
@onready var track_difficulty = $CenterContainer/VBoxContainer/TrackDifficulty

var selected_index = 0

func _ready():
	var global = get_node("/root/Global")
	selected_index = global.selected_track
	update_display()

func update_display():
	var global = get_node("/root/Global")
	var track = global.tracks[selected_index]
	
	# Update global selection
	global.selected_track = selected_index
	
	# Load and display track image
	var image_texture = load(track.image)
	if image_texture:
		track_texture.texture = image_texture
		track_texture.modulate = Color.WHITE
	else:
		# Fallback to color if image not found
		track_texture.texture = null
		track_texture.modulate = track["color"]
	
	track_name.text = track["name"]
	track_difficulty.text = "Difficulty: %s" % track["difficulty"]

func _on_prev_button_pressed():
	var global = get_node("/root/Global")
	selected_index = wrapi(selected_index - 1, 0, global.tracks.size())
	update_display()

func _on_next_button_pressed():
	var global = get_node("/root/Global")
	selected_index = wrapi(selected_index + 1, 0, global.tracks.size())
	update_display()

func _on_back_button_pressed():
	# Return to main menu
	get_tree().change_scene_to_file("res://menu_scene.tscn")
