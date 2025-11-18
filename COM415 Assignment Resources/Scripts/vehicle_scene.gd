extends Control


@onready var vehicle_grid = $VBoxContainer/ScrollContainer/GridContainer
@onready var back_button = $VBoxContainer/BackButton

#const VEHICLE_CARD = preload("res://scenes/vehicle_card.tscn")

var vehicles = [
	{
		"id": 1,
		"name": "Speed Demon",
		"max_speed": 280,
		"acceleration": 85,
		"handling": 70,
		#"icon_path": "res://assets/vehicles/vehicle1.png"
	},
	{
		"id": 2,
		"name": "Thunder Bolt",
		"max_speed": 260,
		"acceleration": 90,
		"handling": 80,
		#"icon_path": "res://assets/vehicles/vehicle2.png"
	},
	{
		"id": 3,
		"name": "Blue Streak",
		"max_speed": 270,
		"acceleration": 85,
		"handling": 75,
		#"icon_path": "res://assets/vehicles/vehicle3.png"
	},
	{
		"id": 4,
		"name": "Green Machine",
		"max_speed": 250,
		"acceleration": 95,
		"handling": 85,
		#"icon_path": "res://assets/vehicles/vehicle4.png"
	},
	{
		"id": 5,
		"name": "Purple Racer",
		"max_speed": 275,
		"acceleration": 80,
		"handling": 72,
		#"icon_path": "res://assets/vehicles/vehicle5.png"
	}
]

func _ready():
	#back_button.pressed.connect(_on_back_pressed)
	populate_vehicles()

func populate_vehicles():
	for vehicle in vehicles:
		pass
#		var card = VEHICLE_CARD.instantiate()
	#	vehicle_grid.add_child(card)
	#	card.setup(vehicle)
	#	card.vehicle_selected.connect(_on_vehicle_selected)

func _on_vehicle_selected(vehicle_data):
	pass
	#GameManager.selected_vehicle = vehicle_data
	#get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_back_pressed():
	pass
	#get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
