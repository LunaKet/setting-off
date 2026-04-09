extends Area3D

const Balloon = preload("uid://dt2cqk7y8kwl0")

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String

signal dialogue_started_alt

func action() -> void:
	print("interacted with actionable")
	#dialogue_started_alt.emit()
	States.dialogue_active_sig.emit()
	var balloon: Node = Balloon.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogue_resource, dialogue_start)
	

	
	
