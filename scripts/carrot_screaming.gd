extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var soundwaves: Node3D = $carrot/soundwaves
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $carrot/AudioStreamPlayer3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("sound")
	States.scream_scale_sig.connect(_change_scale)
	
	scream()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func scream():
	var wait_time = 2
	while true:
		var tween = create_tween()
		wait_time = randi() % 40 + 1	
		tween.tween_callback(audio_stream_player_3d.play).set_delay(wait_time)
		tween.tween_interval(4)
		await tween.finished
	
func _change_scale(value):
	var scale_set = max(0.3, value)
	soundwaves.scale =Vector3(scale_set, scale_set, scale_set)


func _on_area_3d_area_entered(area: Area3D) -> void:
	States.scream_collided()
