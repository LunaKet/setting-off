extends Node3D
@onready var labrynth_hint: MeshInstance3D = $puzzle_labrynth/labrynth_hint

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	States.subtitles_sig.connect(_update_subtitles_hints)
	labrynth_hint.hide()
	
func _update_subtitles_hints(index):
	if index==0:
		labrynth_hint.hide()
	elif index==1:
		labrynth_hint.show()
