extends CanvasLayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	States.end_state_sig.connect(end_state)
	
func end_state():
	print("credits - end state")
	animation_player.play("fade_in")
	show()
