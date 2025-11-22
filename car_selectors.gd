extends Control

# Array to store car data with scene paths
var cars = [
	{
		"name": "Green Car",
		"preview_image": "res://COM415 Assignment Resources/Vehicles/kenney_toy-car-kit/Previews/vehicle-drag-racer.png",
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
		"preview_image": "res://COM415 Assignment Resources/Vehicles/kenney_toy-car-kit/Previews/vehicle-drag-racer.png",
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
@onready var btn_prev = $ButtonPrevious
@onready var btn_next = $ButtonNext
@onready var btn_select = $ButtonSelect
@onready var btn_back = $ButtonBack

func _ready():
	
	set_process_input(true)
	set_process_unhandled_input(true)
	
	print("=== CAR SELECTOR READY ===")
	print("Control can receive input: ", !is_set_as_top_level())
	print("Control mouse filter: ", mouse_filter)
	
	print("=== CAR SELECTOR READY ===")
	
	# Connect TouchScreenButton signals
	if btn_prev:
		btn_prev.pressed.connect(_on_previous_pressed)
		print("Previous button connected")
	
	if btn_next:
		btn_next.pressed.connect(_on_next_pressed)
		print("Next button connected")
	
	if btn_select:
		btn_select.pressed.connect(_on_select_pressed)
		print("Select button connected")
	
	if btn_back:
		btn_back.pressed.connect(_on_back_pressed)
		print("Back button connected")
	
	print("==========================")
	
	update_car_display()

func _input(event):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			print("TOUCH/CLICK at position: ", event.position)

func update_car_display():
	print("--- Updating display for index: ", current_car_index, " ---")
	var car = cars[current_car_index]
	
	# Load preview image
	if car_display and car.has("preview_image") and ResourceLoader.exists(car["preview_image"]):
		var texture = load(car["preview_image"])
		if texture:
			car_display.texture = texture
	
	# Update car name
	if car_name:
		car_name.text = car["name"]
		print("Car name: ", car["name"])
	
	# Update stats
	print("Speed: ", car["stats"]["speed"])
	print("Handling: ", car["stats"]["handling"])
	
	if speed_label:
		speed_label.text = "Speed: " + str(car["stats"]["speed"])
	if handling_label:
		handling_label.text = "Handling: " + str(car["stats"]["handling"])
	
	if speed_bar:
		speed_bar.value = car["stats"]["speed"]
	if handling_bar:
		handling_bar.value = car["stats"]["handling"]

func _on_previous_pressed():
	print("<<< PREVIOUS BUTTON CLICKED >>>")
	current_car_index -= 1
	if current_car_index < 0:
		current_car_index = cars.size() - 1
	update_car_display()

func _on_next_pressed():
	print(">>> NEXT BUTTON CLICKED >>>")
	current_car_index += 1
	if current_car_index >= cars.size():
		current_car_index = 0
	update_car_display()

func _on_back_pressed():
	print("BACK BUTTON CLICKED")
	get_tree().change_scene_to_file("res://menu_scene.tscn")

func _on_select_pressed():
	print("SELECT BUTTON CLICKED")
	var selected_car = cars[current_car_index]
	
	GameManager.selected_car_scene = selected_car["scene_path"]
	GameManager.selected_car_name = selected_car["name"]
	GameManager.selected_car_stats = selected_car["stats"]
	
	print("Selected: ", selected_car["name"])
	
	get_tree().change_scene_to_file("res://menu_scene.tscn")
