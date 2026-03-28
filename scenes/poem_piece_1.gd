extends Node3D
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	States.found_poem_sig.connect(poem)

func poem(index):
	if index==0:
		audio_stream_player_3d.play()
		await audio_stream_player_3d.finished
		queue_free()
