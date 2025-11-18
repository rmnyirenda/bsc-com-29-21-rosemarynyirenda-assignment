extends Node3D

var myCar: VehicleBody3D
@onready var velocityLabel: Label = $Control/vel
@onready var car_spawn_point = $SpawnPoint

func _ready() -> void:
	GameManager.isPlaying = true
	myCar = get_tree().get_first_node_in_group("car")
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	await get_tree().create_timer(0.15).timeout
	spawn_selected_car()
	
func _process(delta: float) -> void:
	updateVelocityLabel()

func updateVelocityLabel():
	if myCar:
		var vel = round(myCar.linear_velocity.length() * 3.6)
		velocityLabel.text= str(vel) + "km/h"
		
func spawn_selected_car():
	
	var car_instance = CarManager.instantiate_car()
	if car_instance:
		car_instance.global_transform = car_spawn_point.global_transform
		
		add_child(car_instance)
		myCar= car_instance
