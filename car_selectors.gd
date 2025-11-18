extends Control

# Array to store car data with scene paths
var cars = [
	{
		"name": "Green Car",
		"preview_image": "res://cars/previews/car1_preview.png",
		"scene_path": "res://COM415 Assignment Resources/Resources/MyCars/race_car_green/race_car_green.tscn",
		"stats": {"speed": 85, "handling": 70}
	},
	{
		"name": "Vehicle Monster Truck",
		"preview_image": "res://COM415 Assignment Resources/Vehicles/kenney_toy-car-kit/Previews/vehicle-monster-truck.png",
		"scene_path": "res://COM415 Assignment Resources/Resources/MyCars/vehicle_monster_truck/vehicle_monster_truck.tscn",
		"stats": {"speed": 75, "handling": 90}
	},
	{
		"name": "Truck",
		"preview_image": "res://COM415 Assignment Resources/Vehicles/kenney_toy-car-kit/Previews/vehicle-truck.png",
		"scene_path": "res://COM415 Assignment Resources/truck/truck.tscn",
		"stats": {"speed": 95, "handling": 60}
	},
	{
		"name": "Red Car",
		"preview_image": "res://cars/previews/car3_preview.png",
		"scene_path": "res://COM415 Assignment Resources/Resources/MyCars/race_car_red/race_car_red.tscn",
		"stats": {"speed": 95, "handling": 60}
	},
	{
		"name": "Drag Racer",
		"preview_image": "res://COM415 Assignment Resources/Vehicles/kenney_toy-car-kit/Previews/vehicle-drag-racer.png",
		"scene_path": "res://COM415 Assignment Resources/Resources/MyCars/vehicle_drag_racer/vehicle_drag_racer.tscn",
		"stats": {"speed": 95, "handling": 60}
	}
]

var current_car_index = 0

@onready var car_display = $CarDisplay
@onready var car_name = $CarName
@onready var speed_label = $SpeedLabel
@onready var handling_label = $HandlingLabel
@onready var speed_bar = $SpeedBar
@onready var handling_bar = $HandlingBar
@onready var btn_back = $ButtonBack

func _ready():
	update_car_display()


func update_car_display():
	var car = cars[current_car_index]
	# Load preview image for UI
	car_display.texture = load(car["preview_image"])
	car_name.text = car["name"]
	
	# Optional: Display stats
	print("Speed: ", car["stats"]["speed"])
	print("Handling: ", car["stats"]["handling"])
	
	speed_bar.value = car["stats"]["speed"]
	handling_bar.value = car["stats"]["handling"]

func _on_previous_pressed():
	current_car_index -= 1
	if current_car_index < 0:
		current_car_index = cars.size() - 1
	update_car_display()

func _on_next_pressed():
	current_car_index += 1
	if current_car_index >= cars.size():
		current_car_index = 0
	update_car_display()

func _on_back_pressed():
	# Return without selecting
	get_tree().change_scene_to_file("res://menu_scene.tscn")

func _on_select_pressed():
	var selected_car = cars[current_car_index]
	
	
	GameManager.selected_car_scene = selected_car["scene_path"]
	GameManager.selected_car_name = selected_car["name"]
	GameManager.selected_car_stats = selected_car["stats"]
	
	print("Selected: ", selected_car["name"])
	
	# Change to racing scene
	get_tree().change_scene_to_file("res://menu_scene.tscn")
