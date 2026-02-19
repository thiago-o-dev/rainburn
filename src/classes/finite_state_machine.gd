extends Node
class_name FiniteStateMachine

@export_category("Controls")
@export var starting_state: State

@export_category("Debug Information")
@export var current_state: State

# func inject_dependencies(...args : Array) -> void

func start() -> void:
	change_state(starting_state)
	return

func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit()
	
	current_state = new_state
	print(get_parent().name, ": ", current_state.name)
	current_state.enter()

func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)

func process_frame(delta: float) -> void:
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)
		
func process_physics(delta: float) -> void:
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)
