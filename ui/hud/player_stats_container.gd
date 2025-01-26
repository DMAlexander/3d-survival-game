extends VBoxContainer


@onready var energy_bar: TextureProgressBar = $EnergyBar
@onready var health_bar: TextureProgressBar = $HealthBar


func _enter_tree() -> void:
	EventSystem.PLA_energy_updated.connect(update_energy)
	EventSystem.PLA_health_updated.connect(update_health)
