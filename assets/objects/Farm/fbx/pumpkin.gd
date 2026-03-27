extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	States.slime_scale_sig.connect(_set_slime_scale)
	
func _set_slime_scale(value):
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector3(value,value,value), 2).set_ease(Tween.EASE_IN_OUT)
	#self.scale = Vector3(value,value,value)
