extends Node3D

@onready var animation_rocko: AnimationPlayer = $AnimationRocko

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	States.rock_eyeball_sig.connect(animate_eyes)
	
func animate_eyes():
	animation_rocko.play("eyeballs")

	
