extends Area2D
class_name InteractableComponent

@export var tooltip : Control
@export var label : Label

@export_category("Controls")
@export var instant : bool = false
@export var freeze_player = true

var is_interacting = false
var player_on_area : bool = false
var player_body : PlayerBody

signal interacted
signal ended_interaction

func _ready():
	interacted.connect(on_interacted)
	ended_interaction.connect(on_ended_interaction)

func on_interacted():
	debug("interacting")
	
	if freeze_player:
		player_body.request_freeze()
	
	is_interacting = true

func on_ended_interaction():
	debug("interaction ended")
	
	if freeze_player:
		player_body.request_unfreeze()
	
	is_interacting = false

func _input(event):
	if not event.is_action_released("Interact"):
		return
	if not player_on_area:
		return
	if is_interacting:
		return
	
	interacted.emit()

func _on_body_entered(body : PlayerBody):
	player_on_area = true
	player_body = body
	debug("player entered")
	if instant:
		is_interacting = true
		interacted.emit()
	#show tooltip

func _on_body_exited(body):
	player_on_area = false
	debug("player left")
	#hide tooltip

func debug(string : String):
	label.text = string
