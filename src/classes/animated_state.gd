@abstract 
class_name AnimatedState extends State

@export
var animation_name: String
var animations: AnimatedSprite2D

func enter() -> void:
	animations.play(animation_name)
