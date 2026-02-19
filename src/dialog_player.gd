extends CanvasLayer

@export_file("*.json") var scene_text_file : String
@export var background : Control
@export var name_label : Label
@export var text_label : Label

var scene_text : Dictionary = {}
var selected_text := []
var in_progress : bool = false

func _ready():
	background.visible = false
	scene_text = load_scene_text()
	SignalBus.display_dialog.connect(_on_display_dialog)

func _on_display_dialog(text_key : String):
	if in_progress:
		next_line()
	else:
		set_text_enviroment(true, text_key)
		selected_text = scene_text[text_key].duplicate()
		show_text()

func next_line():
	if selected_text.size() <= 0:
		finish()
		return
	
	show_text()

func show_text():
	text_label.text = selected_text.pop_front()
	
func finish():
	set_text_enviroment(false)
	text_label.text = ""
	SignalBus.dialog_ended.emit()

func set_text_enviroment(state : bool, dialogue_name : String = "Name"):
	in_progress = state
	background.visible = state
	name_label.text = dialogue_name.capitalize()
	#get_tree().paused = state

func load_scene_text() -> Dictionary:
	if not FileAccess.file_exists(scene_text_file):
		push_warning("Missing file: " + scene_text_file)
		return {}
		
	var file := FileAccess.open(scene_text_file, FileAccess.READ)
	var parsed = JSON.parse_string(file.get_as_text())
	
	if typeof(parsed) != TYPE_DICTIONARY:
		push_warning("Invalid JSON format.")
		return {}
		
	return parsed
