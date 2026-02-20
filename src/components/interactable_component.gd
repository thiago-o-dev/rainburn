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

var tooltip_follow_speed : float = 2.0
@onready var tooltip_starting_position : Vector2 = tooltip.position

signal interacted
signal interaction_ended

func _ready():
	interacted.connect(on_interacted)
	interaction_ended.connect(on_interaction_ended)
	
	if debug_label:
		debug_label.visible = debug_mode
	
	tooltip.modulate.a = 0

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
var scaling_tween : Tween = null
func tween_fade_tooltip(state: bool):
	if fading_tween:
		fading_tween.kill()
	if scaling_tween:
		scaling_tween.kill()
	
	var target_value := 1.0 if state else 0.0
	fading_tween = create_tween()
	fading_tween.set_trans(Tween.TRANS_SINE)
	fading_tween.set_ease(Tween.EASE_IN_OUT)
	
	fading_tween.tween_property(
		tooltip, 
		"modulate:a", 
		target_value, 
		0.2
	)
	
	scaling_tween = create_tween()
	var speed = .5
	if state:
		scaling_tween.set_trans(Tween.TRANS_ELASTIC)
		scaling_tween.set_ease(Tween.EASE_OUT)
	else:
		scaling_tween.set_trans(Tween.TRANS_SINE)
		scaling_tween.set_ease(Tween.EASE_IN_OUT)
		speed = .2
	
	scaling_tween.tween_property(
		tooltip, 
		"scale:x", 
		target_value, 
		speed
	)
	if !state:
		fading_tween.finished.connect(on_fading_tween_end)

func on_fading_tween_end():
	tooltip.position = tooltip_starting_position

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
	
	var target_position := (player_body.global_position - global_position) / 2
	target_position.x -= tooltip.size.x / 2
	
	tooltip.position = tooltip.position.lerp(target_position, delta * tooltip_follow_speed)
