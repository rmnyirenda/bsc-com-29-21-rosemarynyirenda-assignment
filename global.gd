extends Node

# Game state variables
var selected_vehicle = 0
var selected_track = 0

# Car and track resources
var vehicles = [
{
"name": "Muscle Car", 
"color": Color.BLUE,
"scene": "res://COM415 Assignment Resources/truck/truck.tscn",
"image": "res://COM415 Assignment Resources/truck/icon.png"
},
{
"name": "Off-Roader", 
"color": Color.GREEN,
"scene": "res://COM415 Assignment Resources/Resources/MyCars/vehicle_monster_truck/vehicle_monster_truck.tscn",
"image": "res://COM415 Assignment Resources/Resources/MyCars/vehicle_monster_truck/icon.png"
},
{
"name": "Super Car", 
"color": Color.PURPLE,
"scene": "res://COM415 Assignment Resources/Resources/MyCars/vehicle_drag_racer/vehicle_drag_racer.tscn",
"image": "res://COM415 Assignment Resources/Resources/MyCars/vehicle_drag_racer/icon_super.png"
}
]

var tracks = [
{
"name": "Desert Rally", 
"color": Color.SANDY_BROWN,
"scene": "res://COM415 Assignment Resources/Scenes/node.tscn",
"image": "res://COM415 Assignment Resources/Scenes/desert_preview.png",
"difficulty": "Medium"
},
{
"name": "Coastal Run", 
"color": Color.SKY_BLUE,
"scene": "res://COM415 Assignment Resources/Scenes/Surbub.tscn",
"image": "res://COM415 Assignment Resources/Scenes/coastal_preview.png",
"difficulty": "Easy"
},
{
"name": "City Circuit", 
"color": Color.GRAY,
"scene": "res://COM415 Assignment Resources/Scenes/bridge.tscn",
"image": "res://COM415 Assignment Resources/Scenes/city_preview.png",
"difficulty": "Hard"
}
]

# Function to start the game with selected vehicle and track
func start_game():
    if selected_vehicle < 0 or selected_vehicle >= vehicles.size() or \
       selected_track < 0 or selected_track >= tracks.size():
        print("Invalid vehicle or track selection!")
        return
        
    var track_scene_path = tracks[selected_track].scene
    var track_scene = load(track_scene_path)
    
    if track_scene:
        get_tree().change_scene_to_file(track_scene_path)
    else:
        print("Error loading track scene!")
