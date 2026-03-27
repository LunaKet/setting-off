extends AnimatableBody3D

var rise := false
var speed_y = 10
var speed_xz = 5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if rise:
		position = position + Vector3(-delta*speed_xz, delta*speed_y, -delta*speed_xz)

func _on_area_3d_5_foglow_area_entered(area: Area3D) -> void:
	await States.set_timer(1)
	rise=true
	print("rise = true")	
	States.end_state_entered()
