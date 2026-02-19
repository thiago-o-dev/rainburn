extends Node2D

@export var interactable_component : InteractableComponent
@export var dialogue_component : DialogueComponent

func _ready():
	interactable_component.interacted.connect(on_interacted)

func on_interacted():
	print("interacted")
	dialogue_component.activate_dialog()
	SignalBus.dialog_ended.connect(on_dialogue_ended)

func on_dialogue_ended():
	SignalBus.dialog_ended.disconnect(on_dialogue_ended)
	interactable_component.interaction_ended.emit()
