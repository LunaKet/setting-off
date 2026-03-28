extends Node3D

@onready var audio_stream_player: AudioStreamPlayer = $Sounds/AudioStreamPlayer
@onready var settings: CanvasLayer = $Settings
@onready var player_take_2: CharacterBody3D = $player_take2
@onready var fade_ap: AnimationPlayer = $FadeAnimationScene/AnimationPlayer
@onready var fade_animation_scene: Node2D = $FadeAnimationScene
@onready var fence_gate_hinge: Node3D = $Level1/FarmStuff/Fences/fence_gate_hinge
@onready var audio_gate: AudioStreamPlayer3D = $Sounds/Audio_Gate
@onready var chicken_2: Node3D = $Level1/NPCs/chicken2
@onready var pumpkin_2: Node3D = $Level1/pumpkin2
@onready var notebook: Node3D = $"Level1/SettingOff - BookModel_1c2"
@onready var windmill_2: Node3D = $Level1/windmill2
@onready var cloud_animate: AnimationPlayer = $cloud_animate
@onready var cloud_animate_2: AnimationPlayer = $cloud_animate2
@onready var level_3: Node3D = $Level3
@onready var world_environment_level_1: WorldEnvironment = $lighting/WorldEnvironmentLevel1
@onready var rocko: Node3D = $Level2/rocko
@onready var rock_float: Node3D = $Level2/platform_puzzle/platform_big9
@onready var camera_3d_mainmenu: Camera3D = $Camera3D_mainmenu
@onready var main_menu: Node2D = $"Main Menu"
@onready var mm_ap: AnimationPlayer = $"Main Menu/AnimationPlayer"
@onready var cloud_platformfinal: AnimatableBody3D = $cloud_platformfinal
@onready var exit_menu: CanvasLayer = $ExitMenu
@onready var credits: CanvasLayer = $Credits

var cloud_rising = false
var DEBUG = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	settings.hide()
	exit_menu.hide()
	credits.hide()
	States.scream_collided_sig.connect(_on_scream_collision)
	States.gate_opening_sig.connect(_gate_animate_camera)
	States.camera_look_sig.connect(_player_look_at_object)
	States.teleports_updated_sig.connect(settings.set_teleport_options)
	States.initialize_poems()

	fade_animation_scene.hide()
	startgame_fade_animation()
	audio_stream_player.play()
	cloud_animate.play("cloud_platform")
	cloud_animate_2.play("cloud_platform_2")
	#teleport_positions("level1")
	
	States.manage_initial_states()
	
	
func _physics_process(delta: float) -> void:
	if cloud_rising:
		cloud_platformfinal.position.y += delta*5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if DEBUG:
		if Input.is_action_just_pressed("test_camera_point_farmer"):
			print("camera_button")
			#player_take_2.player_look_at(chicken_2)
			settings.slime_volume(15)

func startgame_fade_animation():
	player_take_2.settings_active = true
	fade_animation_scene.show()

	fade_ap.play_backwards("fade_out")
	await fade_ap.animation_finished
	fade_animation_scene.hide()
	
	player_take_2.settings_active = false

func _on_scream_collision():
	#carrot
	player_take_2.settings_active = true
	
	fade_animation_scene.show()
	fade_ap.play("fade_out")
	await fade_ap.animation_finished
	
	player_take_2.position = fence_gate_hinge.global_position + Vector3(0,0,4)
	
	fade_ap.play_backwards("fade_out")
	await fade_ap.animation_finished
	fade_animation_scene.hide()
	
	player_take_2.settings_active = false
	
func _gate_animate_camera():
	player_take_2.player_look_at(fence_gate_hinge)
	audio_gate.play()
	
func _player_look_at_object(obj_str):
	if obj_str == "gate":
		player_take_2.player_look_at(fence_gate_hinge)
	elif obj_str == "chicken":
		player_take_2.player_look_at(chicken_2)


#out of bounds functions
func _on_area_3d_area_entered_under_windmill(area: Area3D) -> void:
	fade("out")
	teleport_positions("pumpkin")
	fade("in")
	
func _on_area_3d_area_entered_level2(area: Area3D) -> void:
	fade("out")
	teleport_positions("rockgf")
	fade("in")

func _on_area_3d_level_3_area_entered(area: Area3D) -> void:
	if !States.end_state:
		fade("out")
		teleport_positions("level3")
		fade("in")
	
func _on_area_3d_4_foghigh_area_entered(area: Area3D) -> void:
	world_environment_level_1.environment.volumetric_fog_density = 0.045
	States.set_spawn_location([3,1])
	States.open_teleport_location([2,0])
	print("foghigh entered")
	
func _on_area_3d_5_foglow_area_entered(area: Area3D) -> void:
	world_environment_level_1.environment.volumetric_fog_density = 0.02

func _on_area_3d_5_level_area_entered(area: Area3D) -> void:
	States.open_teleport_location([1,0])
	States.open_teleport_location([1,1])
	if States.spawn_location[0]<3:
		States.set_spawn_location([2,1])
	
func fade(direction: String):
	if direction=="out":
		player_take_2.settings_active = true
		fade_animation_scene.show()
		fade_ap.play("fade_out")
		await fade_ap.animation_finished
		return
		
	if direction=="in":
		fade_ap.play_backwards("fade_out")
		await fade_ap.animation_finished
		fade_animation_scene.hide()
		player_take_2.settings_active = false	
		return
	
func teleport_positions(location):
	fade("out")
	
	world_environment_level_1.environment.volumetric_fog_density = 0.02
	player_take_2.stop_sfx()
	if location=="level1":
		player_take_2.position = notebook.global_position + Vector3(0,-0.5,3)
	elif location=="pumpkin":
		player_take_2.position = pumpkin_2.global_position + Vector3(0,30,0)
	elif location=="windmill":
		player_take_2.position = windmill_2.global_position + Vector3(0,3,0)
	elif location=="level2":
		player_take_2.position = rocko.global_position + Vector3(-1 ,-0.5,9)
	elif location=="rockgf":
		player_take_2.position = Vector3(152.7, 52.7, 51.9)
	elif location=="level3":
		player_take_2.position = level_3.global_position + Vector3(0,50,40)
		world_environment_level_1.environment.volumetric_fog_density = 0.045
	elif location=="rock_float":
		player_take_2.position = rock_float.global_position + Vector3(0,5,0)
	fade("in")

func _on_settings_teleport_location(location: Variant) -> void:
	if ["level1", "pumpkin", "windmill", "level2", "rockgf", "level3", "rock_float"].has(location):
		teleport_positions(location)

func teleport_start():
	var spawn = States.spawn_location
	if spawn[0] == 1:
		teleport_positions("level1")
	elif spawn[0] == 2:
		teleport_positions("level2")
	elif spawn[0] == 3:
		teleport_positions("level3")
		
 
func _on_main_menu_start_game_sig() -> void:
	camera_3d_mainmenu.queue_free()
	if !DEBUG:
		teleport_start()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	States.start_menu_active = false


func _on_area_3d_area_entered(area: Area3D) -> void:
	cloud_rising = true
	
