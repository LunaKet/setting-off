extends Node3D
@onready var static_body_3d: StaticBody3D = $Cloud1/StaticBody3D
@onready var collision_shape_3d: CollisionShape3D = $Cloud1/StaticBody3D/CollisionShape3D
@onready var cloud_1: MeshInstance3D = $Cloud1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
