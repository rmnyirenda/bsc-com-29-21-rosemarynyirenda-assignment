extends Node3D

@onready var car_spawn_point: Marker3D = $Marker3D

var current_car_instance: Node3D = null
var rotation_speed: float = 1.0

func _ready() -> void:

	spawn_selected_car()

func _process(delta: float) -> void:
	if current_car_instance and is_instance_valid(current_car_instance):
		# Find the main car body (the CharacterBody3D)
		var car_body = current_car_instance
		if not car_body is CharacterBody3D:
			car_body = current_car_instance.find_child("CharacterBody3D")  # Adjust if your car has a different structure
		
		if car_body and is_instance_valid(car_body):
			car_body.rotate_object_local(Vector3.UP, rotation_speed * delta)
	#if current_car_instance:
	#	current_car_instance.rotate_y(rotation_speed * delta)

func spawn_selected_car() -> void:
	if current_car_instance and is_instance_valid(current_car_instance):
		current_car_instance.queue_free()
		current_car_instance = null
	
	# Get the new car instance from CarManager
	var new_car = CarManager.instantiate_car()
	if new_car:
		# Add the car to the scene first
		add_child(new_car)
		current_car_instance = new_car
		
		# Position the car at the spawn point
		new_car.global_transform = car_spawn_point.global_transform
		
		# Scale down the car if it's too large
		var car_mesh = _find_mesh_instance(new_car)
		if car_mesh:
			var scale_factor = 0.5  # Adjust this value to make the car larger or smaller
			car_mesh.scale = Vector3(scale_factor, scale_factor, scale_factor)
		
		# Center the car in the view
		var car_aabb = _get_model_aabb(new_car)
		if car_aabb:
			var center_offset = car_aabb.position + (car_aabb.size / 2.0)
			new_car.global_translate(-center_offset)
		
		# Position the car slightly above the ground
		new_car.global_translate(Vector3(0, 0.5, 0))
		
		# Disable physics for the preview
		if new_car is RigidBody3D:
			new_car.freeze = true
			new_car.collision_layer = 0
			new_car.collision_mask = 0
		
		# Disable camera if it exists in the car
		var camera = new_car.find_child("Camera3D")
		if camera:
			camera.queue_free()
		
		print("Car spawned: ", new_car.name, " at position: ", new_car.global_transform.origin)
	else:
		push_error("Failed to instantiate car")

func _on_next_pressed() -> void:
	var current_index = CarManager.get_selected_car_index()  # Changed from get_selected_car_index()
	var new_index = (current_index + 1) % CarManager.get_car_count()
	CarManager.set_selected_car_index(new_index)
	spawn_selected_car()

func _on_prev_pressed() -> void:
	var current_index = CarManager.get_selected_car_index()  # Changed from get_selected_car_index()
	var new_index = current_index - 1
	if new_index < 0:
		new_index = CarManager.get_car_count() - 1
	CarManager.set_selected_car_index(new_index)
	spawn_selected_car()

func _on_select_pressed() -> void:
	# Save the selected car index
	var save_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	save_game.store_var(CarManager.get_car_index())  # Changed from get_selected_car_index()
	save_game = null  # Close the file
	
	# Load the game scene
	get_tree().change_scene_to_file("res://COM415 Assignment Resources/Scenes/node.tscn")

func _find_mesh_instance(node: Node) -> Node3D:
	if node is MeshInstance3D:
		return node
	
	for child in node.get_children():
		var result = _find_mesh_instance(child)
		if result:
			return result
	return null

func _get_model_aabb(node: Node) -> AABB:
	var aabb: AABB
	
	if node is MeshInstance3D:
		aabb = node.get_aabb()
		return aabb
	
	for child in node.get_children():
		var child_aabb = _get_model_aabb(child)
		if child_aabb != AABB():
			if aabb == AABB():
				aabb = child_aabb
			else:
				aabb = aabb.merge(child_aabb)
	
	return aabb

func _exit_tree() -> void:
	# Clean up when the scene is changed
	if current_car_instance and is_instance_valid(current_car_instance):
		current_car_instance.queue_free()
		current_car_instance = null
