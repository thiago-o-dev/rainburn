extends Node
class_name DialogueComponent

@export var dialog_key : String = ""
var active : bool = false

func _ready():
	SignalBus.dialog_ended.connect(on_dialogue_ended)

func _input(event):
	if active and event.is_action_released("Interact"):
		SignalBus.display_dialog.emit(dialog_key)
		print("called component")
		get_viewport().set_input_as_handled()

func activate_dialog():
	active = true
	SignalBus.display_dialog.emit(dialog_key)

func on_dialogue_ended():
	active = false
