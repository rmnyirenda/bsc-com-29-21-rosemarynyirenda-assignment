
extends Node3D

func _ready():
	spawn_player_car()

func spawn_player_car():
	var car = GameManager.get_selected_car_instance()
	if car:
		add_child(car)
		car.position = Vector3(0, 1, 0)  # Adjust spawn height
		print("Loaded car: ", GameManager.selected_car_name)
