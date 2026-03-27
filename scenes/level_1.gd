extends Node3D
@onready var animation_player_farmer: AnimationPlayer = $AnimationPlayerFarmer
@onready var animation_player_gate: AnimationPlayer = $AnimationPlayerGate
@onready var notebook: Node3D = $"SettingOff - BookModel_1c2"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player_farmer.play("bob")
	States.gate_opening_sig.connect(_open_gate)
	States.book_pickedup_sig.connect(_hide_book)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
func _hide_book():
	notebook.hide()

func _open_gate():
	animation_player_gate.play("gate_open")
