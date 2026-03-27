extends CanvasLayer

func _on_control_exit_menu_sig() -> void:
	if !visible:
		show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true

	elif visible:
		exit_menu()
		
func exit_menu():
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	
func _on_button_pressed_continue() -> void:
	exit_menu()

func _on_button_exit_pressed() -> void:
	get_tree().quit()
	
