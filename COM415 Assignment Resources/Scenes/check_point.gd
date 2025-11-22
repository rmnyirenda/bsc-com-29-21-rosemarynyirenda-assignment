extends Area3D
class_name RaceCheckpoint

signal checkpoint_passed(car, checkpoint_id)

@export var checkpoint_id := 0
@export var race_manager: RaceManager

func _ready():
	pass

func _on_body_entered(body):
	if not race_manager:
		push_error("No RaceManager assigned to checkpoint")
		return
	
	# Only process CharacterBody3D (cars)
	if not body is CharacterBody3D:
		return
	
	var racer_name = ""
	
	# Check if it's a player car
	if body.is_in_group("player"):
		racer_name = "Player"
		emit_signal("checkpoint_passed", body, get_instance_id())
	# Check if it's an AI car
	elif body.is_in_group("ai_car"):
		racer_name = body.name
	# Try to get racer name from method
	elif body.has_method("get_racer_name"):
		racer_name = body.get_racer_name()
	
	# If we found a valid racer, register checkpoint
	if racer_name != "":
		race_manager.checkpoint_passed(racer_name, checkpoint_id)
