extends Control

@onready var vehicle_texture = $CenterContainer/VBoxContainer/HBoxContainer/VehicleTexture
@onready var vehicle_name = $CenterContainer/VBoxContainer/VehicleName
@onready var vehicle_speed = $CenterContainer/VBoxContainer/VehicleStats/Speed/Value
@onready var vehicle_handling = $CenterContainer/VBoxContainer/VehicleStats/Handling/Value

var selected_index = 0

func _ready():
	var global = get_node("/root/Global")
	selected_index = global.selected_vehicle
	update_display()

func update_display():
	var global = get_node("/root/Global")
	var vehicle = global.vehicles[selected_index]
	
	# Update global selection
	global.selected_vehicle = selected_index
	
	# Load and display vehicle image
	var image_texture = load(vehicle.image)
	if image_texture:
		vehicle_texture.texture = image_texture
		vehicle_texture.modulate = Color.WHITE
	else:
		# Fallback to color if image not found
		vehicle_texture.texture = null
		vehicle_texture.modulate = vehicle["color"]
	
	vehicle_name.text = vehicle["name"]
	
	# Set some example stats (you can customize these based on your game's needs)
	var speed = 5 + (selected_index * 2)  # Example calculation
	var handling = 8 - (selected_index * 1)  # Example calculation
	
	vehicle_speed.text = str(speed)
	vehicle_handling.text = str(handling)

func _on_prev_button_pressed():
	var global = get_node("/root/Global")
	selected_index = wrapi(selected_index - 1, 0, global.vehicles.size())
	update_display()

func _on_next_button_pressed():
	var global = get_node("/root/Global")
	selected_index = wrapi(selected_index + 1, 0, global.vehicles.size())
	update_display()

func _on_back_button_pressed():
	# Return to main menu
	get_tree().change_scene_to_file("res://menu_scene.tscn")
