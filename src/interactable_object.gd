extends Node2D

@export var interactable_component : InteractableComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	interactable_component.interacted.connect(on_interacted)

func on_interacted():
	print("interadted")
	await get_tree().create_timer(5.0).timeout
	interactable_component.ended_interaction.emit()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
