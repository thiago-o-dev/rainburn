extends AnimatedState

@export var idle_state: State

@export var walk_speed: float = 300.0
@export var run_speed: float = 500.0

var current_speed = walk_speed
var acceleration = 4000.0

var player_actions_component : PlayerActionsComponent
var parent: CharacterBody2D

func process_input(_event: InputEvent) -> State:
	if get_movement_input() == Vector2.ZERO:
		return idle_state
	
	return null

func process_frame(delta: float) -> State:
	var direction = get_movement_input()
	
	if Input.is_key_pressed(KEY_SHIFT):
		current_speed = run_speed
	else:
		current_speed = walk_speed
	
	var movement = direction * current_speed
	
	#animations.flip_h = movement < 0
	parent.velocity = parent.velocity.move_toward(movement, delta * acceleration) 
	parent.move_and_slide()
	return null

func get_movement_input() -> Vector2:
	return player_actions_component.get_movement_direction()
