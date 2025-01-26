extends Camera3D

@onready var equippable_camera: Camera3D = %EquippableCamera


func _process(_delta: float) -> void:
	equippable_camera.global_transform = global_transform
