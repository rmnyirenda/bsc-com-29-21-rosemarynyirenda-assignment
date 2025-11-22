extends Node3D

@export var race_manager: RaceManager
@export var player_car: CharacterBody3D
@export var ai_cars: Array[Node] = []

func _ready():
	# Wait a frame for everything to initialize
	await get_tree().process_frame
	
	# Register player
	#race_manager.register_racer(player_car, "Player", true)
	
	# Register AI cars
	for ai in ai_cars:
		var ai_name = ai.get_racer_name() if ai.has_method("get_racer_name") else ai.name
		race_manager.register_racer(ai, ai_name, false)
	

	await get_tree().create_timer(3.0).timeout
	race_manager.start_race()
