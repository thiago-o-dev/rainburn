extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("ui_page_up"):
		zoom = Vector2(3,3)
		return
	
	if event.is_action_released("ui_page_up"):
		zoom = Vector2(1,1)
		return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
