extends Control

var vehicles = []
var selected_index = 0
var previous_scene = null

@onready var vehicle_texture = $CenterContainer/VBoxContainer/HBoxContainer/VehicleTexture
@onready var vehicle_name = $CenterContainer/VBoxContainer/VehicleName
@onready var vehicle_stats = $CenterContainer/VBoxContainer/VehicleStats

func _ready():
	update_display()

func update_display():
	var vehicle = vehicles[selected_index]
	
	# Load and display vehicle image
	var image_texture = load(vehicle.image)
	if image_texture:
		vehicle_texture.texture = image_texture
		vehicle_texture.modulate = Color.WHITE
	else:
		# Fallback to color if image not found
		vehicle_texture.texture = null
		vehicle_texture.modulate = vehicle.color
	
	vehicle_name.text = vehicle.name
	vehicle_stats.text = "Speed: %d/10\nAcceleration: %.1f" % [vehicle.speed, vehicle.acceleration]

func _on_prev_button_pressed():
	selected_index = wrapi(selected_index - 1, 0, vehicles.size())
	update_display()

func _on_next_button_pressed():
	selected_index = wrapi(selected_index + 1, 0, vehicles.size())
	update_display()

func _on_back_button_pressed():
	# Save selection back to main menu
	if previous_scene:
		previous_scene.selected_vehicle = selected_index
		previous_scene.update_selected_info()
	
	# Return to main menu
	get_tree().root.add_child(previous_scene)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = previous_scene
