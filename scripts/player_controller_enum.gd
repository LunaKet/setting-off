extends CharacterBody3D

# STATES
enum State {
	IDLE,
	WALK,
	JUMP,
	FALL,
	LAND,
	SETTINGS,
	CINEMATIC,
	DIALOGUE
}

var current_state: State =  State.IDLE

#controlling variables
const JUMP_VELOCITY = 6
var ACCELERATION = 0.8
var SPEED = 2.1
var walking_speed = 2.1
var running_speed = 5.0
var sens_horizontal = 0.05
var sens_vertical = 0.05

# some stuff to keep track of
var settings_active := false
var cinematic_active := false
var dialogue_active := false
var stored_fall_velocity: float

#logic variables
var running = false
var always_running = false
var land_timer = 0.5

#signals
signal settings_button_sig


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
	#DialogueManager.dialogue_started.connect(_on_dialogue_manager_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_manager_dialogue_ended)
	States.dialogue_active_sig.connect(_on_dialogue_active_sig)
			
func _unhandled_input(event):
	if is_controls_on_check_vars():
		if Input.is_action_just_pressed("action_button"):
				var actionables = actionable_finder.get_overlapping_areas()
				if actionables.size() > 0:
					actionables[0].action()
					return 
					
		#not in the spirit of the state machine
		#if i wanted, could create a script-global variable or pass the event to every state function that needs it
		elif event is InputEventMouseMotion: 
			rotate_y(deg_to_rad(-event.relative.x * sens_horizontal * global_vars.mouse_sens))
			camera_mount.rotate_x(deg_to_rad(-event.relative.y * sens_vertical * global_vars.mouse_sens))
			
func _physics_process(delta: float) -> void:
	_process_state(delta)
	move_and_slide() #might have to move to specific states or adjust
	
func _apply_gravity(delta: float) -> void:
	#only apply airborne
	if not is_on_floor():
		velocity += get_gravity() * delta

func _process_state(delta: float) -> void:
	match current_state:
		State.IDLE: _state_idle()
		State.WALK: _state_walk()
		State.JUMP: _state_jump()
		State.FALL: _state_fall(delta)
		State.LAND: _state_land(delta)
		State.SETTINGS: _state_settings()
		State.DIALOGUE: _state_dialogue()
		State.CINEMATIC: _state_cinematic()
		
func _state_idle():
	velocity.x = move_toward(velocity.x, 0.0, ACCELERATION)
	velocity.z = move_toward(velocity.z, 0.0, ACCELERATION)
	
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")

	#transitions
	if input_dir[0] != 0.0 or input_dir[1] != 0.0:
		_change_state(State.WALK)
	elif Input.is_action_just_pressed("jump") and is_on_floor(): 
		_change_state(State.JUMP)
	elif !is_on_floor():
		_change_state(State.FALL)
	elif Input.is_action_just_pressed("menu"):
		_change_state(State.SETTINGS)
		
func _state_walk() -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	#check if walking or running speed
	if Input.is_action_pressed("sprint") or always_running:
		SPEED = running_speed
		running=true
	else:
		SPEED = walking_speed
		running=false
		
	velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION)
	velocity.z = move_toward(velocity.z, direction.z * SPEED, ACCELERATION)
	
	#AUDIO
	if !audio_stream_player_3d_walk.is_playing() and !audio_stream_player_3d_run.is_playing():
		if running:
			audio_stream_player_3d_run.play()
		else:
			audio_stream_player_3d_walk.play()
				
	#transitions
	if input_dir[0] == 0.0 and input_dir[1] == 0.0:
		_change_state(State.IDLE)
	elif Input.is_action_just_pressed("jump") and is_on_floor(): 
		_change_state(State.JUMP)
	elif !is_on_floor():
		_change_state(State.FALL)
	elif Input.is_action_just_pressed("menu"):
		_change_state(State.SETTINGS)

func _state_jump() -> void:
	#an impulse then immediately fall
	velocity.y = JUMP_VELOCITY
	_change_state(State.FALL)

func _state_fall(delta: float) -> void:
	_apply_gravity(delta)
	
	#duplicate of walking/movement code
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if Input.is_action_pressed("sprint") or always_running:
		SPEED = running_speed
		running=true
	else:
		SPEED = walking_speed
		running=false
		
	velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION)
	velocity.z = move_toward(velocity.z, direction.z * SPEED, ACCELERATION)
	
	#keep track of fall velocity
	if velocity.y < stored_fall_velocity:
		stored_fall_velocity = velocity.y
	
	if velocity.y<-20:
		if !audio_stream_player_3d_fall.is_playing():
			audio_stream_player_3d_fall.play()
	
	#transitions
	if is_on_floor():
		audio_stream_player_3d_fall.stop()
		_change_state(State.LAND)
	elif Input.is_action_just_pressed("menu"):
		_change_state(State.SETTINGS)

func _state_land(delta) -> void:
	##can add in animation later
	#velocity.x = move_toward(velocity.x, 0.0, ACCELERATION*5)
	#land_timer -= delta

	#fall sound, if big enough drop. may have to adjust
	if stored_fall_velocity<-2.0: 
		audio_stream_player_3d_endjump.play()
	stored_fall_velocity = 0.0

	#if land_timer <= 0.0:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	if input_dir[0] != 0.0 or input_dir[1] != 0.0:
		_change_state(State.WALK)
	else:
		_change_state(State.IDLE)
	
func _state_settings():
	velocity.x = move_toward(velocity.x, 0.0, ACCELERATION)
	velocity.z = move_toward(velocity.z, 0.0, ACCELERATION)
	if Input.is_action_just_pressed("menu") or settings_active==false: #menu button vs. clickable button on settings menu
		if Input.is_action_just_pressed("menu"): #a bit circular but this fixes it for now. otherwise clicking menu button causes a double signal.
			settings_button_sig.emit()
		if stored_fall_velocity != 0.0:
			_change_state(State.FALL)
			velocity.y = stored_fall_velocity
			stored_fall_velocity = 0.0
		else:
			_change_state(State.IDLE)
			
func _state_dialogue():
	velocity.x = move_toward(velocity.x, 0.0, ACCELERATION)
	velocity.z = move_toward(velocity.z, 0.0, ACCELERATION)
	velocity.y = 0

	#transitions - only valid path is to idle
	if !dialogue_active:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		_change_state(State.IDLE)
		#this will go from IDLE->FALL in one frame if dialogue was activated during a jump
	
func _state_cinematic():
	if !cinematic_active:
		_change_state(State.DIALOGUE)
	
# HELPERS
func _change_state(new_state: State) -> void:
	#Don't re-enter same state
	if new_state == current_state:
		return
	
	## Entry Actions (not needed at the moment
	match new_state:
		#State.LAND: 
			#land_timer = LAND_DURATION
		State.SETTINGS:
			settings_active = true
			stored_fall_velocity = velocity.y
			settings_button_sig.emit()
		State.DIALOGUE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		State.CINEMATIC:
			cinematic_active = true
			
	current_state = new_state

# pointing character camera
func player_look_at(target):
	_change_state(State.CINEMATIC)
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
func _on_dialogue_manager_dialogue_ended(_resource: DialogueResource) -> void:
	print("dialogue inactive")
	dialogue_active = false #on the next frame State.DIALOGUE will take this and switch to State.IDLE
	States.dialogue_active = false
	
func _on_dialogue_active_sig():
	dialogue_active = true #on the next frame State.DIALOGUE will take this and switch to State.IDLE
	States.dialogue_active = true
	print("states dialogue active, _on_dialogue_active_sig")	
	_change_state(State.DIALOGUE)
	
#func _on_dialogue_manager_dialogue_started(_resource: DialogueResource) -> void:
	#print("dialogue active")
	#dialogue_active = true
	#States.dialogue_active = true
	#print("states dialogue, _on_dialogue_manager_dialogue_started")
	#print(States.dialogue_active)
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)	
	
#func _on_area_3d_dialogue_started_alt() -> void:
	#print("dialogue active")
	#dialogue_active = true
	#print("states dialogue, _on_area_3d_dialogue_started_alt")
	#print(States.dialogue_active)
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_settings_visibility_changed() -> void:
	print("settings visibility")
	if settings.visible:
		settings_active = true
		#player_take_2.get_tree().paused = true
		#stored_fall_vel_bool = true
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
