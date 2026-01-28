extends AnimatedState

@export var move_state: State

var player_actions_component : PlayerActionsComponent
var parent: CharacterBody2D
const DAMPENING : float = 1000.0

func process_input(_event: InputEvent) -> State:
	if get_movement_input() != Vector2.ZERO:
		return move_state
	
	return null
	
func process_frame(delta: float) -> State:
	parent.velocity = parent.velocity.move_toward(Vector2.ZERO, delta*DAMPENING)
	parent.move_and_slide()
	
	return null

func get_movement_input() -> Vector2:
	return player_actions_component.get_movement_direction()
