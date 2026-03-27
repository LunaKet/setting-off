extends Node

#Default values are set at the beginning, outside of the functions. this also allows other scripts to access them
#Config file is loaded, which overwrites the defaults if a key exists
#If there's no config file, one is created with all the values.
#For every setting, this requires 3 different locations for information. Error-prone.

#SettingsExtra
var hints_available: int = 1
var void_mode: int = 0
var scene_id: int = 0
var pointer_visible: int = 1

#SettingsAudio
var master_volume: float = 1.0
var music_volume: float = 1.0
var sfx_volume: float = 1.0
var scream_volume: float = 1.0
var slime_volume: float = 1.0

#SettingsGraphics
var window_mode: bool = true
var antialias: int = 1
var FPS: int = 1
var VSYNC: bool = true
var shadow_mode: int = 1
var scaling_3d: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var config_load := ConfigFile.new()
	
	#This loads in the config file if one has *ever* been created.
	var error := config_load.load("user://settings.cfg")
	if error == OK:
		print("config loaded")
		
		#SettingsExtra		
		hints_available = config_load.get_value("SettingsExtra", "hints_available", hints_available)
		void_mode = config_load.get_value("SettingsExtra", "void_mode", void_mode)
		scene_id = config_load.get_value("SettingsExtra", "scene_id", scene_id)
		pointer_visible = config_load.get_value("SettingsExtra", "pointer_visible", pointer_visible)
		
		#SettingsAudio
		master_volume = config_load.get_value("SettingsAudio", "master_volume", master_volume)
		music_volume = config_load.get_value("SettingsAudio", "music_volume", music_volume)
		sfx_volume = config_load.get_value("SettingsAudio", "sfx_volume", sfx_volume)
		scream_volume = config_load.get_value("SettingsAudio", "sfx_volume", scream_volume)
		slime_volume = config_load.get_value("SettingsAudio", "sfx_volume", slime_volume)

		#SettingsGraphics
		window_mode = config_load.get_value("SettingsGraphics", "window_mode", window_mode)
		antialias = config_load.get_value("SettingsGraphics", "antialias", antialias)
		FPS = config_load.get_value("SettingsGraphics", "FPS", FPS)
		VSYNC = config_load.get_value("SettingsGraphics", "VSYNC", VSYNC)
		shadow_mode = config_load.get_value("SettingsGraphics", "shadow_mode", shadow_mode)
		scaling_3d = config_load.get_value("SettingsGraphics", "scaling_3d", scaling_3d)
		save_game()
		
	else:
		print("creating settings file")
		save_game()
#
func save_game():
	print("saving game")
	var config := ConfigFile.new()
	
	#SettingsExtra
	config.set_value("SettingsExtra", "hints_available", hints_available)
	config.set_value("SettingsExtra", "void_mode", void_mode)
	config.set_value("SettingsExtra", "scene_id", scene_id)
	config.set_value("SettingsExtra", "pointer_visible", pointer_visible)
	
	#SettingsAudio
	config.set_value("SettingsAudio", "master_volume", master_volume)
	config.set_value("SettingsAudio", "music_volume", music_volume)
	config.set_value("SettingsAudio", "sfx_volume", sfx_volume)
	config.set_value("SettingsAudio", "scream_volume", scream_volume)
	config.set_value("SettingsAudio", "slime_volume", slime_volume)

	
	#SettingsGraphics
	config.set_value("SettingsGraphics", "window_mode", window_mode)
	config.set_value("SettingsGraphics", "antialias", antialias)
	config.set_value("SettingsGraphics", "FPS", FPS)
	config.set_value("SettingsGraphics", "VSYNC", VSYNC)
	config.set_value("SettingsGraphics", "shadow_mode", shadow_mode)
	config.set_value("SettingsGraphics", "scaling_3d", scaling_3d)
	
	#Save
	config.save("user://settings.cfg")
