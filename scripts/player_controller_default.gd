extends CharacterBody3D


#controlling variables
const JUMP_VELOCITY = 6
var SPEED = 5
var walking_speed = 2.1
var running_speed = 5.0
var sens_horizontal = 0.05
var sens_vertical = 0.05

var settings_active := false
var cinematic_active := false
var dialogue_active := false

var stored_fall_velocity: float
var stored_fall_vel_bool := false
var previous_is_on_floor := true

#logic variables
var running = false
var always_running = false

#handles, renamed
@onready var camera_mount: Node3D = $camera_mount
@onready var actionable_finder: Area3D = $Area3D
@onready var settings: CanvasLayer = $"../Settings"
@onready var player_take_2: CharacterBody3D = $"."
@onready var fence_gate_hinge: Node3D = $"../Level1/FarmStuff/Fences/fence_gate_hinge"
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var camera_3d: Camera3D = $camera_mount/Camera3D

@onready var audio_stream_player_3d_walk: AudioStreamPlayer3D = $AudioStreamPlayer3D_walk
@onready var audio_stream_player_3d_run: AudioStreamPlayer3D = $AudioStreamPlayer3D_run
@onready var audio_stream_player_3d_fall: AudioStreamPlayer3D = $AudioStreamPlayer3D_fall
@onready var audio_stream_player_3d_endjump: AudioStreamPlayer3D = $AudioStreamPlayer3D_endjump

#called when game starts
func _ready():
	#important for pausing player controls
	DialogueManager.dialogue_started.connect(_on_dialogue_manager_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_manager_dialogue_ended)
	States.dialogue_active_sig.connect(_on_dialogue_active_sig)
			
func _unhandled_input(event):
	if is_controls_on_check_vars():
		if Input.is_action_just_pressed("action_button"):
				var actionables = actionable_finder.get_overlapping_areas()
				if actionables.size() > 0:
					actionables[0].action()
					return 
		elif event is InputEventMouseMotion:
			rotate_y(deg_to_rad(-event.relative.x * sens_horizontal * global_vars.mouse_sens))
			camera_mount.rotate_x(deg_to_rad(-event.relative.y * sens_vertical * global_vars.mouse_sens))
			
func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	if is_controls_on_check_vars():
		if not is_on_floor():
			velocity += get_gravity() * delta
			previous_is_on_floor = false
			if velocity.y<-20:
				if !audio_stream_player_3d_fall.is_playing():
					audio_stream_player_3d_fall.play()
					
			
		if stored_fall_vel_bool:
			velocity.y = stored_fall_velocity
			stored_fall_vel_bool = false
	
		var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		if Input.is_action_just_pressed("jump") and is_on_floor(): 
			velocity.y = JUMP_VELOCITY
		elif direction:
			if Input.is_action_pressed("sprint") or always_running:
				SPEED = running_speed
				running=true
			else:
				SPEED = walking_speed
				running=false
				
			velocity.x = move_toward(velocity.x, direction.x * SPEED, 1)
			velocity.z = move_toward(velocity.z, direction.z * SPEED, 1)
			
			if is_on_floor():
				if !audio_stream_player_3d_walk.is_playing() and !audio_stream_player_3d_run.is_playing():
					if running:
						audio_stream_player_3d_run.play()
					else:
						audio_stream_player_3d_walk.play()
		
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	if !previous_is_on_floor and is_on_floor():
		audio_stream_player_3d_endjump.play()
		previous_is_on_floor = true

	move_and_slide()

# pointing character camera
func player_look_at(target):
	set_cinematic_active(true)
	var target_rotation = transform.looking_at(target.global_position).basis
	var tween = create_tween()
	tween.tween_method(interpolate.bind(target_rotation), 0.0, 1.0, 1.5).set_trans(Tween.TRANS_QUAD)
	tween.tween_callback(set_cinematic_active.bind(false))
	
func interpolate(weight, end_basis):
	self.transform.basis = transform.basis.slerp(end_basis, weight).orthonormalized()
	
func set_cinematic_active(on_off: bool):
	cinematic_active = on_off
	
#Sounds
func stop_sfx():
	for ap in [audio_stream_player_3d_walk, audio_stream_player_3d_run, audio_stream_player_3d_fall]:
		ap.stop()
	
# connected signal functions
func _on_dialogue_manager_dialogue_started(_resource: DialogueResource) -> void:
	print("dialogue active")
	dialogue_active = true
	States.dialogue_active = true
	print("states dialogue, _on_dialogue_manager_dialogue_started")
	print(States.dialogue_active)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_dialogue_manager_dialogue_ended(_resource: DialogueResource) -> void:
	print("dialogue inactive")
	dialogue_active = false
	States.dialogue_active = false
	print("states dialogue")
	print(States.dialogue_active)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _on_dialogue_active_sig():
	print("dialogue active")
	dialogue_active = true
	States.dialogue_active = true
	print("states dialogue, _on_dialogue_active_sig")
	print(States.dialogue_active)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	stored_fall_vel_bool = true
	stored_fall_velocity = velocity.y
	velocity.y=0.0
	
func _on_area_3d_dialogue_started_alt() -> void:
	print("dialogue active")
	dialogue_active = true
	print("states dialogue, _on_area_3d_dialogue_started_alt")
	print(States.dialogue_active)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_settings_visibility_changed() -> void:
	print("settings visibility")
	if settings.visible:
		settings_active = true
		#player_take_2.get_tree().paused = true
		stored_fall_vel_bool = true
		stored_fall_velocity = velocity.y
		velocity.y=0.0
	elif !settings.visible:
		settings_active = false
		#player_take_2.get_tree().paused = false
		

	
func _on_fov_value_changed(value: float) -> void:
	var tween = create_tween()
	var fov_tween_duration = 0.5
	tween.tween_property(camera_3d, "fov", value, fov_tween_duration)
	#camera_3d.fov = value
	tween.parallel().tween_property(collision_shape_3d, "scale", Vector3(value/75, value/75, value/75), fov_tween_duration)
	#collision_shape_3d.scale = Vector3(value/75, value/75, value/75)
	
#Logic
# Logic checks
func is_controls_on_check_vars():
	if cinematic_active:
		return false
	elif dialogue_active:
		return false
	elif settings_active:
		return false
	else:
		return true

func _on_always_sprint_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		always_running = true
	else:
		always_running = false
