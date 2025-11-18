extends Resource
class_name CarData

# Basic Information
@export var car_name: String = "Default Car"
@export var description: String = "A standard racing vehicle"
@export var scene_path: String = "res://path/to/default_car.tscn"
@export var preview_texture: Texture2D  # For UI display

# Performance Stats (0.0 - 10.0 scale)
@export_range(0.0, 10.0, 0.1) var speed: float = 5.0
@export_range(0.0, 10.0, 0.1) var acceleration: float = 5.0
@export_range(0.0, 10.0, 0.1) var handling: float = 5.0
@export_range(0.0, 10.0, 0.1) var braking: float = 5.0
@export_range(0.0, 10.0, 0.1) var traction: float = 5.0

# Audio
@export var engine_sound_path: String = "res://sounds/engines/default_engine.ogg"
@export var horn_sound_path: String = "res://sounds/horns/default_horn.ogg"

# Visual Customization
@export var primary_color: Color = Color.WHITE
@export var secondary_color: Color = Color.GRAY
@export var has_turbo_effect: bool = false

# Internal use
var _cached_scene: PackedScene = null

# Get the car scene, with caching
func get_car_scene() -> PackedScene:
	if _cached_scene == null and ResourceLoader.exists(scene_path):
		_cached_scene = load(scene_path)
	return _cached_scene

# Validate the resource
func is_valid() -> bool:
	if car_name.is_empty():
		push_warning("Car name is empty")
		return false
	if not ResourceLoader.exists(scene_path):
		push_warning("Scene path does not exist: " + scene_path)
		return false
	return true

# Get all stats as a dictionary
func get_stats() -> Dictionary:
	return {
		"speed": speed,
		"acceleration": acceleration,
		"handling": handling,
		"braking": braking,
		"traction": traction
	}

# Create a duplicate with overridden properties
func with_overrides(overrides: Dictionary) -> CarData:
	var new_car = self.duplicate()
	for property in overrides:
		if new_car.get(property) != null:
			new_car.set(property, overrides[property])
	return new_car
