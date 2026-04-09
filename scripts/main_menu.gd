extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal start_game_sig
var game_started = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("fade_in")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_startgame_button_pressed() -> void:
	if !game_started:
		game_started = true
		animation_player.play_backwards("fade_in")
		await animation_player.animation_finished
		start_game_sig.emit()
		

func _on_exit_button_pressed() -> void:
	if !game_started:
		get_tree().quit()
