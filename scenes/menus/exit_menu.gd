extends CanvasLayer

func _on_control_exit_menu_sig() -> void:
	if !visible:
		show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
		States.exit_menu_active = true

	elif visible:
		exit_menu()
		
		
func exit_menu():
	States.exit_menu_active = false
	if !States.menu_active():
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hide()
	get_tree().paused = false
	
func _on_button_pressed_continue() -> void:
	exit_menu()

func _on_button_exit_pressed() -> void:
	get_tree().quit()
	
