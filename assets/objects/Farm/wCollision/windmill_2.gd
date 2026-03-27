extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("wind")
	#
func _process(delta: float) -> void:
	if !audio_stream_player_3d.is_playing():
		audio_stream_player_3d.play()
