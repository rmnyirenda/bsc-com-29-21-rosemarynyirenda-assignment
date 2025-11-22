extends Control

var car_names = ["Car 1", "Car 2", "Car 3"]
var current_index = 0

@onready var label = $CarLabel


func _ready():

	update_display()


func _on_button_pressed():
	print("BUTTON CLICKED!")
	current_index += 1
	if current_index >= car_names.size():
		current_index = 0
	update_display()

func update_display():
	label.text = car_names[current_index]
	print("Showing: ", car_names[current_index])
