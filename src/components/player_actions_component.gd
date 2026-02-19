extends Node
class_name PlayerActionsComponent

func get_movement_direction() -> Vector2:
	var direction = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down")).normalized()
	#print(direction)
	return direction
