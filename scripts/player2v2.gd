extends CharacterBody3D


#controlling variables
const JUMP_VELOCITY = 6
var SPEED = 5
@export var walking_speed = 2.1
@export var running_speed = 5.0
var sens_horizontal = 0.05
var sens_vertical = 0.05

#rotation variables
#var target_basis: Quaternion
#var target_origin: Vector3
#var smooth_rotation: Quaternion

#logic variables
var running := false
var dialogue_active := false
var settings_active := false
var cinematic_active := false
var stored_fall_velocity: float
var stored_fall_vel_bool := false

#signals
signal settings_menu_pressed

#handles, renamed
@onready var camera_mount: Node3D = $camera_mount
@onready var camera_3d: Camera3D = $camera_mount/Camera3D
@onready var actionable_finder: Area3D = $Area3D
@onready var settings: CanvasLayer = $"../Settings"
@onready var player_take_2: CharacterBody3D = $"."
@onready var fence_gate_hinge: Node3D = $"../Level1/FarmStuff/Fences/fence_gate_hinge"
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D


#called when game starts
func _ready():
	#important for pausing player controls
	
	DialogueManager.dialogue_started.connect(_on_dialogue_manager_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_manager_dialogue_ended)
	States.dialogue_active_sig.connect(_on_dialogue_active_sig)
	print(DialogueManager.dialogue_started.get_connections())

				
func _unhandled_input(event):
	if is_controls_on_check_vars():
		if Input.is_action_just_pressed("action_button"):
				var actionables = actionable_finder.get_overlapping_areas()
				if actionables.size() > 0:
					actionables[0].action()
					return
		elif event is InputEventMouseMotion:
			rotate_y(deg_to_rad(-event.relative.x * sens_horizontal))
			camera_mount.rotate_x(deg_to_rad(-event.relative.y * sens_vertical))
			
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_controls_on_check_vars():
		var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		if stored_fall_vel_bool:
			velocity.y = stored_fall_velocity
			stored_fall_vel_bool = false
		
		if Input.is_action_just_pressed("jump") and is_on_floor(): 
			print("jump")
			velocity.y = JUMP_VELOCITY
		elif direction:
			print(input_dir.x)
			print(input_dir.y)
			if Input.is_action_pressed("sprint"):
				SPEED = running_speed
				running=true
			else:
				SPEED = walking_speed
				running=false
				
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			#
			#if is_on_floor():
				#if !audio_footsteps_walk.is_playing() and !audio_footsteps_run.is_playing():
					#if running:
						#audio_footsteps_run.play()
					#else:
						#audio_footsteps_walk.play()
		
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
			#
		#if velocity.y > 20:
			#if !audio_stream_player_fall.isplaying():
				#audio_stream_player_fall.play()
		#
		#elif velocity.y<1:
	

func _on_dialogue_manager_dialogue_started(_resource: DialogueResource) -> void:
	print("dialogue active")
	dialogue_active = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_dialogue_manager_dialogue_ended(_resource: DialogueResource) -> void:
	print("dialogue inactive")
	dialogue_active = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _on_dialogue_active_sig():
	print("dialogue active")
	dialogue_active = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_area_3d_dialogue_started_alt() -> void:
	print("dialogue active")
	dialogue_active = true
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
	

#This is for the silly FOV behavior. The world appears to become larger/smaller but it's actually you	
func _on_fov_value_changed(value: float) -> void:
	var tween = create_tween()
	var fov_tween_duration = 0.5
	tween.tween_property(camera_3d, "fov", value, fov_tween_duration)
	#camera_3d.fov = value
	tween.parallel().tween_property(collision_shape_3d, "scale", Vector3(value/75, value/75, value/75), fov_tween_duration)
	#collision_shape_3d.scale = Vector3(value/75, value/75, value/75)
	
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
	
