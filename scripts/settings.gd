extends CanvasLayer
#@onready var environment: Environment = get_tree().current_scene.get_node("WorldEnvironment").environment
@onready var button: Button = $MarginContainer/VBoxContainer/MarginContainer2/Button
@onready var tab_container: TabContainer = $MarginContainer/VBoxContainer/TabContainer

#extra settings
@onready var voidmode: OptionButton = $MarginContainer/VBoxContainer/TabContainer/VBoxExtras/HBoxContainer/voidmode
@onready var scene_button: OptionButton = $MarginContainer/VBoxContainer/TabContainer/VBoxExtras/HBoxContainer2/scene_option
@onready var hints_button: OptionButton = $MarginContainer/VBoxContainer/TabContainer/VBoxExtras/HBoxContainer3/hints_option
@onready var cursor_button: OptionButton = $MarginContainer/VBoxContainer/TabContainer/VBoxExtras/HBoxContainer4/cursor_option

#Audio Settings
@onready var master_slider: HSlider = $MarginContainer/VBoxContainer/TabContainer/VBoxAudio/HBoxContainer/MasterSlider
@onready var music_slider: HSlider = $MarginContainer/VBoxContainer/TabContainer/VBoxAudio/HBoxContainer2/MusicSlider
@onready var sfx_slider: HSlider = $MarginContainer/VBoxContainer/TabContainer/VBoxAudio/HBoxContainer3/SFXSlider
@onready var scream_slider: HSlider = $MarginContainer/VBoxContainer/TabContainer/VBoxAudio/HBoxContainer4/ScreamSlider
@onready var slime_slider: HSlider = $MarginContainer/VBoxContainer/TabContainer/VBoxAudio/HBoxContainer5/SlimeSlider

#Graphics Settings
@onready var check_button_fs: CheckButton = $MarginContainer/VBoxContainer/TabContainer/VBoxGraphics/HBoxWindow/CheckButtonFS
@onready var check_button_vsync: CheckButton = $MarginContainer/VBoxContainer/TabContainer/VBoxGraphics/HBoxWindow/CheckButtonVSYNC
@onready var check_button_0: CheckButton = $MarginContainer/VBoxContainer/TabContainer/VBoxGraphics/VBoxAA/HBoxAA4/CheckButton0
@onready var check_button_2x: CheckButton = $MarginContainer/VBoxContainer/TabContainer/VBoxGraphics/VBoxAA/HBoxAA4/CheckButton2x
@onready var check_button_4x: CheckButton = $MarginContainer/VBoxContainer/TabContainer/VBoxGraphics/VBoxAA/HBoxAA4/CheckButton4x
@onready var check_fps_30: CheckButton = $MarginContainer/VBoxContainer/TabContainer/VBoxGraphics/HBoxFPS/CheckFPS30
@onready var check_fps_60: CheckButton = $MarginContainer/VBoxContainer/TabContainer/VBoxGraphics/HBoxFPS/CheckFPS60
@onready var check_shadows_hard: CheckButton = $MarginContainer/VBoxContainer/TabContainer/VBoxGraphics/VBoxShadows/HBoxShadowButtons/CheckShadowsHard
@onready var check_shadows_soft: CheckButton = $MarginContainer/VBoxContainer/TabContainer/VBoxGraphics/VBoxShadows/HBoxShadowButtons/CheckShadowsSoft
@onready var check_shadows_softest: CheckButton = $MarginContainer/VBoxContainer/TabContainer/VBoxGraphics/VBoxShadows/HBoxShadowButtons/CheckShadowsSoftest
@onready var scaling_3d_label: Label = $MarginContainer/VBoxContainer/TabContainer/VBoxGraphics/HBoxScale/scaling_3d_label
@onready var scaling_3d_slider: HSlider = $MarginContainer/VBoxContainer/TabContainer/VBoxGraphics/HBoxScale/res_scale
@onready var fov_label: Label = $MarginContainer/VBoxContainer/TabContainer/VBoxGraphics/HBoxFOV/Label3
@onready var fov_slider: HSlider = $MarginContainer/VBoxContainer/TabContainer/VBoxGraphics/HBoxFOV/FOV

#teleport buttons to hide
@onready var tele_farm: Label = $MarginContainer/VBoxContainer/TabContainer/VBoxExtras/HBoxTeleOptions1/tele_farm
@onready var tele_farm_check: CheckButton = $MarginContainer/VBoxContainer/TabContainer/VBoxExtras/HBoxTeleOptions1/tele_farm_check
@onready var tele_rocko: Label = $MarginContainer/VBoxContainer/TabContainer/VBoxExtras/HBoxTeleOptions1/tele_rocko
@onready var tele_rocko_check: CheckButton = $MarginContainer/VBoxContainer/TabContainer/VBoxExtras/HBoxTeleOptions1/tele_rocko_check
@onready var tele_lab: Label = $MarginContainer/VBoxContainer/TabContainer/VBoxExtras/HBoxTeleOptions1/tele_lab
@onready var tele_lab_check: CheckButton = $MarginContainer/VBoxContainer/TabContainer/VBoxExtras/HBoxTeleOptions1/tele_lab_check
@onready var tele_windmill: Label = $MarginContainer/VBoxContainer/TabContainer/VBoxExtras/HBoxTeleOptions2/tele_windmill
@onready var tele_windmill_check: CheckButton = $MarginContainer/VBoxContainer/TabContainer/VBoxExtras/HBoxTeleOptions2/tele_windmill_check
@onready var tele_float: Label = $MarginContainer/VBoxContainer/TabContainer/VBoxExtras/HBoxTeleOptions2/tele_float
@onready var tele_float_check: CheckButton = $MarginContainer/VBoxContainer/TabContainer/VBoxExtras/HBoxTeleOptions2/tele_float_check

# Sounds
@onready var audio_open: AudioStreamPlayer = $Audio_open
@onready var audio_close: AudioStreamPlayer = $Audio_close


#signal FOV_sig(value)
signal teleport_location(location)

func _ready() -> void:
	tab_container.current_tab = 0
	master_slider.value = global_vars.master_volume
	music_slider.value = global_vars.music_volume
	sfx_slider.value = global_vars.sfx_volume
	scream_slider.value = 1.0
	slime_slider.value = 15	

	set_graphics_to_config_vars()
	set_teleport_options()

func set_graphics_to_config_vars():
	window_mode(global_vars.window_mode)
	vsync(global_vars.VSYNC)
	fps_all(global_vars.FPS)
	antialias_all(global_vars.antialias)
	shadow_all(global_vars.shadow_mode)
	scaling_3D(global_vars.scaling_3d)
	set_FOV(75)
	
func set_graphics_to_default_vars():
	window_mode(true)
	vsync(true)
	fps_all(60)
	antialias_4x(true)
	shadow_all(1)
	scaling_3D(1)
	set_FOV(75)
	
func set_teleport_options():
	#farm is always available
	tele_windmill.hide()
	tele_windmill_check.hide()
	tele_rocko.hide()
	tele_rocko_check.hide()
	tele_float.hide()
	tele_float_check.hide()
	tele_lab.hide()
	tele_lab_check.hide()
	
	if States.teleports_opened[0][1]:
		tele_windmill.show()
		tele_windmill_check.show()
	if States.teleports_opened[1][0]:
		tele_rocko.show()
		tele_rocko_check.show()
		tele_float.show()
		tele_float_check.show()
	if States.teleports_opened[2][0]:
		tele_lab.show()
		tele_lab_check.show()

## GRAPHICS
func window_mode(toggled_on: bool):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		check_button_fs.button_pressed = true
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		check_button_fs.button_pressed = false
	global_vars.window_mode = toggled_on
	
func vsync(toggled_on: bool):
	if toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		check_button_vsync.button_pressed = true
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		check_button_vsync.button_pressed = false
	global_vars.VSYNC = toggled_on
	
func fps_30(toggled: bool):
	if toggled:
		fps_all(30)

func fps_60(toggled: bool):
	if toggled:
		fps_all(60)
	
func fps_all(value):
	if value==30:
		Engine.max_fps = 30
		check_fps_30.button_pressed = true
	elif value==60:
		Engine.max_fps = 60
		check_fps_60.button_pressed = true
	global_vars.FPS = value
	print(Engine.max_fps)

func antialias_0(toggled: bool):
	if toggled:
		antialias_all(0)
		
func antialias_2x(toggled: bool):
	if toggled:
		antialias_all(2)
		
func antialias_4x(toggled: bool):
	if toggled:
		antialias_all(4)

func antialias_all(index):
	if index==0:
		get_viewport().msaa_3d = Viewport.MSAA_DISABLED
		check_button_0.button_pressed = true
	elif index==2:
		get_viewport().msaa_3d = Viewport.MSAA_2X
		check_button_2x.button_pressed = true
	elif index==4:
		get_viewport().msaa_3d = Viewport.MSAA_4X
		check_button_4x.button_pressed = true
	global_vars.antialias = index
	
func shadow_hard(toggled: bool):
	if toggled:
		shadow_all(0)

func shadow_soft(toggled: bool):
	if toggled:
		shadow_all(1)

func shadow_softest(toggled: bool):
	if toggled:
		shadow_all(2)
	
func shadow_all(index):
	if index==0:
		RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_HARD)
		RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_HARD)
		check_shadows_hard.button_pressed = true
	elif index==1:
		RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_LOW)
		RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_LOW)
		check_shadows_soft.button_pressed = true
	elif index==2:
		RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_HIGH)
		RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_HIGH)
		check_shadows_softest.button_pressed = true
	global_vars.shadow_mode = index
	
func scaling_3D(value):
	get_viewport().scaling_3d_scale = value
	#get a text output as well
	var label = "3D Scaling, \n" + str(int(value*100)) + "%"
	scaling_3d_label.text = label
	scaling_3d_slider.value = value
	global_vars.scaling_3d = value
	#
func set_FOV(value):
	var label = "FOV, " + str(int(value)) + "°"
	fov_label.text = label
	fov_slider.value = value

		
## AUDIO
func master_volume(value):
	print(value)
	AudioServer.set_bus_volume_linear(0, value)
	global_vars.master_volume = value
	
func music_volume(value):
	AudioServer.set_bus_volume_linear(1, value)
	global_vars.music_volume = value
	if value < 0.2:
		States.music_is_soft = true
	else:
		States.music_is_soft = false

func sfx_volume(value):
	AudioServer.set_bus_volume_linear(2, value)
	global_vars.sfx_volume = value
	
	if global_vars.sfx_volume < global_vars.scream_volume:
		scream_volume(value)
	
func scream_volume(value):
	AudioServer.set_bus_volume_linear(3, value)
	global_vars.scream_volume = value
	States.set_scream_scale(value)
	
func slime_volume(value):
	global_vars.slime_volume = value
	States.set_slime_scale(value)
	

## TELEPORT
func teleport_farm(toggled: bool):
	if toggled:
		tele_all("level1")

func teleport_wind(toggled: bool):
	if toggled:
		tele_all("windmill")
		
func teleport_rockgf(toggled: bool):
	if toggled:
		tele_all("level2")
		
func teleport_lab(toggled: bool):
	if toggled:
		tele_all("level3")
		
func teleport_rockfloat(toggled: bool):
	if toggled:
		tele_all("rock_float")
	
func tele_all(location):
	teleport_location.emit(location)
	
#Subtitles
func _on_option_button_item_selected(index: int) -> void:
	States.change_subtitles(index)
	
## EXTRAS

		
	
	
# Menu functionality
func _on_settings_menu_pressed() -> void:
	if !States.start_menu_active and !States.dialogue_active:
		if !visible:
				
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			if _verify_audio_is_free():
				audio_open.play()
			visible = true	
			States.settings_active = true

		elif visible:
			_on_button_pressed()
			if _verify_audio_is_free():
				audio_close.play()
	#get_tree().paused = true				
	
func _verify_audio_is_free():
	if !audio_close.is_playing() and !audio_open.is_playing():
		return true
	else:
		return false
	
func _on_button_pressed() -> void:
	States.settings_active = false
	if !States.menu_active():
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	global_vars.save_game()
	hide()

#func _on_visibility_changed() -> void:
	#if visible:
		#button.grab_focus()
