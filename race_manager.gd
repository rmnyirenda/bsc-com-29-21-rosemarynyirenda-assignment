extends Node
class_name RaceManager

signal lap_completed(car_name: String, lap_number: int, lap_time: float)
signal race_finished(car_name: String, position: int, total_time: float)

@export var total_laps := 3
@export var checkpoint_count := 4  # Number of checkpoints per lap

var racers := {}  # Dictionary to track each racer
var race_started := false
var race_start_time := 0.0
var finished_racers := []

class RacerData:
	var car: Node
	var current_lap := 0
	var checkpoints_passed := 0
	var lap_start_time := 0.0
	var total_time := 0.0
	var finished := false
	var is_player := false
	
	func _init(_car: Node, _is_player: bool = false):
		car = _car
		is_player = _is_player

func _ready():
	pass

func register_racer(car: Node, racer_name: String, is_player: bool = false):
	var data = RacerData.new(car, is_player)
	racers[racer_name] = data
	print("Registered racer: ", racer_name)

func start_race():
	race_started = true
	race_start_time = Time.get_ticks_msec() / 1000.0
	
	for racer_name in racers:
		var racer = racers[racer_name]
		racer.current_lap = 1
		racer.checkpoints_passed = 0
		racer.lap_start_time = race_start_time
		racer.total_time = 0.0
		racer.finished = false
	
	print("Race started!")

func checkpoint_passed(racer_name: String, checkpoint_id: int):
	if not race_started or not racers.has(racer_name):
		return
	
	var racer = racers[racer_name]
	if racer.finished:
		return
	
	# Check if this is the next expected checkpoint
	if checkpoint_id == racer.checkpoints_passed:
		racer.checkpoints_passed += 1
		
		# Check if completed all checkpoints (lap finished)
		if racer.checkpoints_passed >= checkpoint_count:
			_complete_lap(racer_name)

func _complete_lap(racer_name: String):
	var racer = racers[racer_name]
	var current_time = Time.get_ticks_msec() / 1000.0
	var lap_time = current_time - racer.lap_start_time
	
	emit_signal("lap_completed", racer_name, racer.current_lap, lap_time)
	print("%s completed lap %d in %.2f seconds" % [racer_name, racer.current_lap, lap_time])
	
	racer.current_lap += 1
	racer.checkpoints_passed = 0
	racer.lap_start_time = current_time
	
	# Check if race is finished
	if racer.current_lap > total_laps:
		_finish_race(racer_name)
	
func _finish_race(racer_name: String):
	var racer = racers[racer_name]
	racer.finished = true
	racer.total_time = (Time.get_ticks_msec() / 1000.0) - race_start_time
	
	finished_racers.append(racer_name)
	var position = finished_racers.size()
	
	emit_signal("race_finished", racer_name, position, racer.total_time)
	print("%s finished in position %d with time %.2f seconds" % [racer_name, position, racer.total_time])
	
	# Check if player finished
	if racer.is_player:
		_show_race_results(racer_name, position, racer.total_time)

func _show_race_results(_racer_name: String, _position: int, _total_time: float):
	# This will be connected to your UI
	print("=== RACE COMPLETE ===")
	print("Position: %d" % _position)
	print("Total Time: %.2f seconds" % _total_time)

func get_racer_position(racer_name: String) -> int:
	if not racers.has(racer_name):
		return 0
	
	var racer = racers[racer_name]
	var position = 1
	
	for other_name in racers:
		if other_name == racer_name:
			continue
		var other = racers[other_name]
		
		# Compare by laps first, then checkpoints
		if other.current_lap > racer.current_lap:
			position += 1
		elif other.current_lap == racer.current_lap and other.checkpoints_passed > racer.checkpoints_passed:
			position += 1
	
	return position

func get_current_lap(racer_name: String) -> int:
	if racers.has(racer_name):
		return racers[racer_name].current_lap
	return 0

func reset_race():
	race_started = false
	finished_racers.clear()
	for racer_name in racers:
		var racer = racers[racer_name]
		racer.current_lap = 0
		racer.checkpoints_passed = 0
		racer.finished = false
