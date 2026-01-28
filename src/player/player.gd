extends CharacterBody2D

@onready var character_animations: AnimatedSprite2D = $CharacterSprite2D
@onready var player_state_machine: FiniteStateMachine = $PlayerStateMachine
@onready var player_actions_component = $PlayerActionsComponent


func _ready() -> void:
	player_state_machine.inject_dependencies(self, character_animations, player_actions_component)

func _process(delta):
	player_state_machine.process_frame(delta)

func _unhandled_input(event):
	player_state_machine.process_input(event)
