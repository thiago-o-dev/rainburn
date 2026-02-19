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
		
	var dependencies := {
		"parent": parent,
		"animations": animations,
		"player_actions_component": player_actions_component
	}
	
	for child in get_children():
		for key in dependencies.keys():
			if key in child:
				child.set(key, dependencies[key])
			else:
				push_warning(child.name + " state does not have '" + key + "'")
