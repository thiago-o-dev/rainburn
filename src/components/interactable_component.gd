extends Area2D
class_name InteractableComponent

@export var tooltip : Control
@export var debug_label : Label

@export_category("Controls")
@export var instant : bool = false
@export var freeze_player = true
@export var debug_mode : bool = false

var is_interacting = false
var player_on_area : bool = false
var player_body : PlayerBody

signal interacted
signal interaction_ended

func _ready():
	interacted.connect(on_interacted)
	interaction_ended.connect(on_interaction_ended)
	
	if debug_label:
		debug_label.visible = debug_mode

func on_interacted():
	debug("interacting")
	
	if freeze_player:
		player_body.request_freeze()
	
	is_interacting = true
	tween_fade_tooltip(false)

func on_interaction_ended():
	debug("interaction ended")
	
	if freeze_player:
		player_body.request_unfreeze()
	
	is_interacting = false
	tween_fade_tooltip(true if player_body else false)
	

func _unhandled_input(event):
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
	
	tween_fade_tooltip(true)
	
	if instant:
		is_interacting = true
		interacted.emit()
		

var fading_tween : Tween = null
func tween_fade_tooltip(state: bool):
	if fading_tween:
		fading_tween.kill()
	
	fading_tween = create_tween()
	#fading_tween.set_trans(Tween.TRANS_SINE)
	fading_tween.set_ease(Tween.EASE_IN_OUT)
	var target_alpha := 1.0 if state else 0.0
	
	fading_tween.tween_property(
		tooltip, 
		"modulate:a", 
		target_alpha, 
		0.5
	)

func _on_body_exited(body):
	player_on_area = false
	player_body = null
	debug("player left")
	tween_fade_tooltip(false)
	#hide tooltip

func debug(string : String):
	if !debug_mode:
		return
	
	debug_label.text = string

func _process(delta: float) -> void:
	if not (visible and player_body):
		return
	
	tooltip.position = (player_body.global_position - global_position)/2
	tooltip.position.x -= tooltip.size.x/2
