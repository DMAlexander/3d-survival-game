extends Interactable
class_name InteractableCooker

@onready var cooking_timer: Timer = $CookingTimer
@onready var food_visuals_holder: Marker3D = $FoodVisualsHolder
@onready var fire_particles: GPUParticles3D = $GPUParticles3D
@onready var fire_light: OmniLight3D = $OmniLight3D
@onready var audio_stream_player: AudioStreamPlayer3D = $AudioStreamPlayer3D

@export var fire_always_on := true

var cooking_recipe: CookingRecipeResource

enum CookingStates {
	Inactive,
	ReadyToCook,
	Cooking,
	Cooked
}

var state := CookingStates.Inactive


func _ready() -> void:
	if fire_always_on:
		fire_particles.emitting = true
		fire_light.show()
		audio_stream_player.play()


func start_interaction() -> void:
	EventSystem.BUL_create_bulletin.emit(
		BulletinConfig.Keys.CookingMenu,
		[
			cooking_recipe,
			0 if state != CookingStates.Cooking or not cooking_recipe else (cooking_recipe.cooking_time - cooking_timer.time_left),
			self,
			state
		]
	)


func uncooked_item_added(recipe: CookingRecipeResource) -> void:
	state = CookingStates.ReadyToCook
	cooking_recipe = recipe
	food_visuals_holder.add_child(cooking_recipe.uncooked_item_visuals.instantiate())


func uncooked_item_removed() -> void:
	state = CookingStates.Inactive
	cooking_recipe = null
	clear_food_visuals()


func cooked_item_removed() -> void:
	state = CookingStates.Inactive
	cooking_recipe = null
	clear_food_visuals()


func clear_food_visuals() -> void:
	for child in food_visuals_holder.get_children():
		child.queue_free()


func start_cooking() -> void:
	state = CookingStates.Cooking
	cooking_timer.start(cooking_recipe.cooking_time)
	
	if not fire_always_on:
		fire_particles.emitting = true
		fire_light.show()
		audio_stream_player.play()


func cooking_finished() -> void:
	state = CookingStates.Cooked
	clear_food_visuals()
	
	if not fire_always_on:
		fire_particles.emitting = false
		fire_light.hide()
		audio_stream_player.stop()
	
	food_visuals_holder.add_child(cooking_recipe.cooked_item_visuals.instantiate())
