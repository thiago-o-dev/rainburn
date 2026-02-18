extends FiniteStateMachine
class_name PlayerStateMachine

@export var frozen_state : State

func request_freeze() -> void:
	change_state(frozen_state)

func request_unfreeze() -> void:
	change_state(starting_state)

func inject_dependencies(
	parent: CharacterBody2D, 
	animations: AnimatedSprite2D, 
	player_actions_component: PlayerActionsComponent
	) -> void:
	for child in get_children():
		if 'parent' in child:
			child.parent = parent
		else:
			print("warn: " + child.name + "does not have 'parent'")
			
		if 'animations' in child:
			child.animations = animations
		else:
			print("warn: " + child.name + "does not have 'animations'")
			
		if 'player_actions_component' in child:
			child.player_actions_component = player_actions_component
		else:
			print("warn: " + child.name + "does not have 'player_actions_component'")
