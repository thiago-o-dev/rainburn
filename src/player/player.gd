extends CharacterBody2D
class_name PlayerBody

@onready var character_animations: AnimatedSprite2D = $CharacterSprite2D
@onready var player_state_machine: PlayerStateMachine = $PlayerStateMachine
@onready var player_actions_component = $PlayerActionsComponent

func request_freeze() -> void:
	player_state_machine.request_freeze()

func request_unfreeze() -> void:
	player_state_machine.request_unfreeze()

func _ready() -> void:
	player_state_machine.inject_dependencies(self, character_animations, player_actions_component)

func _process(delta):
	player_state_machine.process_frame(delta)

func _unhandled_input(event):
	player_state_machine.process_input(event)
