extends Node

#UserData
var spawn_location = [1, 1] #level, spawn point
var poem_pieces = [false, false, false, false, false, false, false, false]
var teleports_opened = [[true, false], [false, false], [false]] # [[farm, windmill], [rocko, rock-float], [labyrinth]]

#start menu
var start_menu_active := true

# level 1
var book_is_pickedup := false
var music_is_soft := false
var gate_is_open := false
var farmer_chicken_comment := false
var scream_collisions: int = 0

#level 2
var introduced_rock := false
var roquette_pet := false

#level 3
var subtitles = 1
var end_state = false

signal book_pickedup_sig
signal gate_opening_sig
signal camera_look_sig(string)
signal scream_scale_sig(value)
signal slime_scale_sig(value)
signal scream_collided_sig
signal dialogue_active_sig
signal rock_eyeball_sig
signal teleports_updated_sig
signal subtitles_sig(index)
signal end_state_sig

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_file()
#
func manage_initial_states():
	if book_is_pickedup:
		book_pickedup()
	if gate_is_open:
		gate_opening_sig.emit()

func load_file():
	var data_load := ConfigFile.new()
	
	#This loads in the config file if one has *ever* been created.
	var error := data_load.load("user://savedata.cfg")
	if error == OK:
		print("savedata loaded")
		
		#UserData
		spawn_location = data_load.get_value("UserData", "spawn_location", spawn_location)
		poem_pieces = data_load.get_value("UserData", "poem_pieces", poem_pieces)
		teleports_opened = data_load.get_value("UserData", "teleports_opened", teleports_opened)
		
		#StateData
		book_is_pickedup = data_load.get_value("StateData", "book_is_pickedup", book_is_pickedup)
		gate_is_open = data_load.get_value("StateData", "gate_is_open", gate_is_open)
		farmer_chicken_comment = data_load.get_value("StateData", "farmer_chicken_comment", farmer_chicken_comment)
		introduced_rock = data_load.get_value("StateData", "introduced_rock", introduced_rock)
		roquette_pet = data_load.get_value("StateData", "roquette_pet", roquette_pet)

		#Save game
		save_game()
		
	else:
		print("creating settings file")
		save_game()

func save_game():
	print("saving game")
	var data_save := ConfigFile.new()
	
	#UserData
	data_save.set_value("UserData", "spawn_location", spawn_location)
	data_save.set_value("UserData", "poem_pieces", poem_pieces)
	data_save.set_value("UserData", "teleports_opened", teleports_opened)
		
	#StateData
	data_save.set_value("StateData", "book_is_pickedup", book_is_pickedup)
	data_save.set_value("StateData", "gate_is_open", gate_is_open)
	data_save.set_value("StateData", "farmer_chicken_comment", farmer_chicken_comment)
	data_save.set_value("StateData", "introduced_rock", introduced_rock)
	data_save.set_value("StateData", "roquette_pet", roquette_pet)
	
	#Save
	data_save.save("user://savedata.cfg")
	
	
## Level 1
func book_pickedup():
	book_is_pickedup = true
	book_pickedup_sig.emit()
	save_game()

func _set_lv1_gate_open():
	gate_is_open = true
	gate_opening_sig.emit()
	camera_look_sig.emit("gate")
	save_game()
	
func set_chicken_comment():
	farmer_chicken_comment = true
	camera_look_sig.emit("chicken")
	save_game()
	
func set_spawn_location(Array):
	spawn_location = Array
	save_game()
	
func open_teleport_location(Array):
	teleports_opened[Array[0]][Array[1]] = true
	teleports_updated_sig.emit()
	save_game()
	
func scream_collided():
	print("carrot collided")
	scream_collided_sig.emit()
	scream_collisions += 1
	print("scream collisions")
	print(scream_collisions)
	
func set_scream_scale(value):
	scream_scale_sig.emit(value)

func set_slime_scale(value):
	slime_scale_sig.emit(value)

#Level 2
func rock_eye_animation():
	rock_eyeball_sig.emit()
	

#Level 3
func change_subtitles(index: int) -> void:
	subtitles = index
	subtitles_sig.emit(index)
	
func end_state_entered():
	print("states - end state")
	end_state = true
	end_state_sig.emit()
	
		
	
func set_dialogue_active():
	dialogue_active_sig.emit()
	
func set_timer(time: float):
	await get_tree().create_timer(time).timeout
	
